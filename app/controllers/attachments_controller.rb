#encoding:utf-8
class AttachmentsController < ApplicationController

	load_and_authorize_resource
	
	def create
		@attachment = Attachment.new(params[:attachment])
		@attachment.user = current_user
		#raise params.inspect
		@app = App.find(@attachment.attachable_id)
		
		if @attachment.save
			MyMailer.sendmail(current_user.email, "Sua solicitação de deploy foi encaminhada para a equipe de suporte. \r\n \r\nRelease Notes: \r\n#{@attachment.release_notes}", 
				"requisição deploy: #{@app.nome}")
			redirect_to "/home/submeter/#{@attachment.attachable_id}", :notice => "Arquivo submetido com sucesso.", :app_id => @attachment.attachable_id
		else
			render template: "home/submeter", id: "#{@attachment.attachable_id}"
		end
	end

	def destroy
		@attachment = Attachment.find(params[:id])
		@attachment.destroy
		# redirect_to home_request_dep_path, :notice => "Successfully destroyed app.", :app_id => @attachment.attachable_id, :id => @attachment.attachable_id
		render nothing: true, :status => 200
	end

end
