#encoding: utf-8
require 'net/smtp'

class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :deployer]

  def index
  	@app = App.new

  end

  def secretarias
  	@secretarias = Secretaria.all
    authorize! :update, Secretaria.new
  end
  def appservers
  	@appservers = Appserver.all
    authorize! :update, Appserver.new
  end
  def apps
    if params[:sec]
      @sec = Secretaria.find(params[:sec])
      @apps = @sec.apps
    elsif params[:server]
      @server = Appserver.find(params[:server])
      @apps = @server.apps
    else
      #@apps = App.all
      @apps = App.order('nome ASC').all
    end
    authorize! :update, App.new
  end

  def dynamic_form
    unless params[:app_id].blank?
      app_tmp = App.find(params[:app_id])
      if current_user.apps.include? app_tmp
        @app = app_tmp
      end
    end
  end

  def request_dep
    authorize! :read, App.new
    unless params[:app_id].blank?
      @app = App.find(params[:app_id])
    end
  end

  def submeter
    @attachment = Attachment.new
    authorize! :update, @attachment
    unless params[:id].blank?
      @app = App.find(params[:id])
      unless current_user.apps.include? @app
        raise(CanCan::AccessDenied, 'Requisição de acesso inválida. Se você discorda, contate o administrador do sistema. Adicionalmente, um log foi gerado.')
      end
      @logs = @app.logs
    end
  end

  def log
    server = Appserver.find(params[:id])
    file = params[:file]

    if server.tomcat?
      Net::SCP.start(server.ip, server.duser, {:port => server.port} ) do |scp|
        scp.download!(server.path + "/logs/" + file, './public/downloads/')
      end
    elsif server.jboss?
      jserver = params[:jserver]
      Net::SCP.start(server.ip, server.duser, {:port => server.port} ) do |scp|
        scp.download!(server.path + "/domain/servers/#{jserver}/log/" + file, './public/downloads/')
      end
    end
    
    send_file "#{Rails.root}/public/downloads/#{file}"
  end


end
