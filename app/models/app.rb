class App < ActiveRecord::Base
  belongs_to :secretaria
  has_many :attachments, :as => :attachable
  
  has_and_belongs_to_many :appservers
  has_and_belongs_to_many :homologacaos, association_foreign_key: :appserver_id, join_table: :apps_appservers
  has_and_belongs_to_many :producaos,    association_foreign_key: :appserver_id, join_table: :apps_appservers
  has_and_belongs_to_many :users
  
  attr_accessible :link, :nome, :appserver, :secretaria, :secretaria_id, :appservers, :appserver_ids, :user_ids, :ultima_acao, :user_acao
  attr_accessible :appservers_attributes, :users_attributes

  attr_accessible :attachments_attributes, :attachments

  accepts_nested_attributes_for :appservers
  accepts_nested_attributes_for :attachments, :allow_destroy => true
  accepts_nested_attributes_for :users
  

  def name
  	self.nome
  end

  def logs

    @logs = []
    self.appservers.each do |server|
      if server.tomcat?
        result = nil
        Net::SSH.start(  server.ip, server.duser, {:port => server.port} ) do |ssh|
          result = ssh.exec!("ls -ths #{server.path}/logs").split("\n")
        end
        result.delete_at 0
        result.first(5).each do |r|
          f = FileLog.new
          f.servidor = server.id
          f.file_name = r.split(' ')[1]
          f.file_path = server.path + "/logs/" + f.file_name
          f.server = 'tomcat-server1'
          f.tamanho = r.split(' ')[0]
          @logs << f
        end
      elsif server.jboss?
        result = nil
        Net::SSH.start( server.ip, server.duser, {:port => server.port} ) do |ssh|
          result = ssh.exec!("ls -ad #{server.path}/domain/servers/#{self.nome.downcase}*").split("\n")

          result.each do |r|
            unless r.include? 'ls'
              cluster = r.sub("#{server.path}/domain/servers/",'')
              unless ssh.exec!("ls -ad #{server.path}/domain/servers/#{cluster}/log/server.log").include? "ls:"
                f = FileLog.new
                f.servidor = server.id
                f.file_name = "server.log"
                f.server = cluster
                f.file_path = server.path + "/domain/servers/#{cluster}/log/server.log"
                f.tamanho = ' '
                #Net::SSH.start( server.ip, server.duser, {:port => server.port} ) do |ssh|
                #  f.tamanho = ssh.exec!("ls -ths #{server.path}/domain/servers/#{r}/log/server.log").split("\n").split(" ")[0]
                #end
                @logs << f
              end
            end
          end
        end
      end
    end
    @logs 
  end

end
