#encoding:utf-8
require 'ansisys'
require 'net/ssh'
require 'net/scp' 


class DeployerController < ApplicationController
	
	before_filter :config_server
	before_filter :render_action, :only => [:restart, :start, :stop, :status]
	before_filter :update_status, :only => [:deploy]

	def config_server
		@tipo = params[:tipo]
		unless params[:s].blank?
			@server=Appserver.find(params[:s])
			if @server.blank?
				return server_not_found("Servidor não localizado!")
			end
			aFile = File.new(Rails.root.join('config').to_s+"/deploy/#{@server.type.downcase}.rb", "w+")
				aFile.puts "require 'capistrano/console' \n "
				aFile.puts "role :app, %w{deploy@#{@server.ip}}"
				aFile.puts "@server '#{@server.ip}', user: '#{@server.duser}', roles: %w{app}, tipo: '#{@server.duser}', ssh_options: {keys: %w(~/.ssh/id_rsa), port: #{@server.port}, forward_agent: false, auth_methods: %w(publickey password)}"	
			aFile.close
		else
			unless params[:app_id].blank?
				@app = App.find(params[:app_id])
				if @app.attachments.blank? or ( @app.attachments[-2].blank? and params[:op] == 'R' )
					return file_not_found
				end
				@servers = (@tipo == 'H' ? @app.homologacaos : (@tipo == 'P' ? @app.producaos : []))
				unless @servers.blank?
					aFile = File.new(Rails.root.join('config').to_s+"/deploy/tomcat.rb", "w+")
					aFile.puts "require 'capistrano/console' \n "
					@servers.each do |server|
						aFile.puts "role :app, %w{#{server.duser}@#{server.ip}}"
						aFile.puts "server '#{server.ip}', user: '#{server.duser}', roles: %w{app}, tipo: '#{server.duser}', ssh_options: {keys: %w(~/.ssh/id_rsa), port: #{server.port}, forward_agent: false, auth_methods: %w(publickey password)}"	
					end
					aFile.close
				else
					return server_not_found("Servidor não cadastrado para a aplicação!")
				end
			end
		end

	end

	def file_not_found
		@result ||= "Não foi possível localizar nenhum arquivo para fazer o deploy/rollback #{@tipo == 'H' ? 'homologação' : 'produção'}."
	end

	def server_not_found(text)
		@result ||= "Servidor não localizado ou não há servidores cadastrados para esta operação!"
	end

	def update_status
		@app ||= App.find(params[:app_id])
		@app.updated_at = Time.now
		@app.ultima_acao = params[:op]
		@app.user_acao = current_user.email
		@app.save #atualizar o campo updated_at
	end

	def render_action
		@result = ansi_escape %x(cap tomcat tomcat:#{params[:action]})
		render text: "<br/ ><div style='background-color:black; padding:12px'>"+@result+"</div>", format: :html, layout: true
	end

	def restart
	end

	def start
	end

	def stop
	end

	def status
	end

	def deploy
		unless @result.blank?
			return
		end
		@result = ""

		if(params[:op] == 'D')

			@servers.each do |server|
				if server.servidor.upcase == 'JBOSS'
					Net::SCP.start( server.ip, server.duser, {:port => server.port}) do |scp| 
						@result = scp.upload!( "public/#{@app.attachments.last.file}", '.' ) 
						#scp.download!( 'test.txt', '.' ) 
						if @result.blank?
							Net::SSH.start( server.ip, server.duser, {:port => server.port} ) do|ssh| 
								#@result = ssh.exec!(" #{server.path}/bin/jboss-cli.sh --connect --controller=#{server.ip} --timeout='60000' --command='deploy #{@app.attachments.last.filename} --server-groups=#{@app.nome}-server-group'") 
								@result = ssh.exec!(" #{server.path}/bin/jboss-cli.sh --connect --controller=#{server.ip} --timeout='60000' --command='deploy #{@app.attachments.last.filename} --server-groups=#{@app.nome}-server-group'") 
								if (@result || '').include? '--force'
									@result = ssh.exec!(" #{server.path}/bin/jboss-cli.sh --connect --controller=#{server.ip} --timeout='60000' --command='deploy #{@app.attachments.last.filename} --force' ") 
								end
							end
						end
						@result ||= "Deploy efetuado com sucesso!"
					end
				elsif server.servidor.upcase == 'TOMCAT'
					Net::SCP.start( server.ip, server.duser, {:port => server.port}) do |scp| 
						my_file = Rails.root.join("public#{@app.attachments.last.file}").to_s
						@result = scp.upload!( my_file, server.dpath ) 
						@result ||= "Deploy efetuado com sucesso!"
					end
				end
			end

		end 
		if(params[:op] == 'R')
			if @app.attachments[-2].blank?
				return render text: "<br/ ><div style='background-color:black; padding:12px'>"+"<font color='red'>Não possui arquivo de rollback!</font>"+"</div>", format: :html, layout: true
			end
			fpath = @app.attachments[-2].file
			dpath = @app.appservers.first.dpath
			@result = ansi_escape %x(FILE='#{fpath}' DPATH='#{dpath}' cap tomcat tomcat:#{params[:action]} )
		end
		if(params[:op] == 'U')
			file = @app.attachments.last.filename
			dpath = @app.appservers.first.dpath
			@result = ansi_escape %x(FILE='#{file}' DPATH='#{dpath}' cap tomcat tomcat:undeploy)
		end 
	end

	protected
	def ansi_escape(string)
	    terminal = AnsiSys::Terminal.new
	    terminal.echo(string)
	    terminal.render 
	end

end
