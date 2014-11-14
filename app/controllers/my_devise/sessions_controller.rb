#encoding:utf-8
require 'net/smtp'
class MyDevise::SessionsController < Devise::SessionsController
  

  def create

    return super

  	@user = User.new(params[:user])

    settings = ActionMailer::Base.smtp_settings
    smtp = Net::SMTP.new(settings[:address], settings[:port])
    if settings[:enable_starttls_auto]
      smtp.enable_starttls_auto if smtp.respond_to?(:enable_starttls_auto) 
    end

    begin
      @teste = true
      smtp.start(settings[:domain], @user.email, params[:user][:password],
      settings[:authentication]) do |smtp| 
      end
    rescue Net::SMTPAuthenticationError
      @teste = false
    end

    if @teste 
      userdb = User.find_by_email(@user.email)
      if userdb.blank?
        @user = User.create(params[:user])
      elsif userdb.password != @user.password
        userdb.update_attributes(params[:user])
      end
      super
    else
    	redirect_to new_user_session_url, :alert => 'Usuário ou senha Inválidos. Use as credenciais do email para se logar.'
    end
  end

  def new
    super
  end

  

end 