class AppsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :authorize_app

	load_and_authorize_resource

	def authorize_app
		authorize! :read, App.new
	end

	def index
		@apps = App.all
	end

	def show
		@app = App.find(params[:id])
		@logs = @app.logs
	end

	def new
		@app = App.new
	end

	def create
		@app = App.new(params[:app])
		if @app.save
			redirect_to @app, :notice => "Successfully created app."
		else
			render :action => 'new'
		end
	end

	def edit
		@app = App.find(params[:id])
	end

	def update
		@app = App.find(params[:id])
		if @app.update_attributes(params[:app])
			redirect_to @app, :notice => "Successfully updated app."
		else
			render :action => 'edit', :notice => "deu aguia."
		end
	end

	def destroy
		@app = App.find(params[:id])
		@app.destroy
		redirect_to apps_url, :notice => "Successfully destroyed app."
	end

end
