#encoding:utf-8
class MyMailer < ActionMailer::Base

  default from: "Codata Deployer <#{ENV["ZIMBRA_USERNAME"]}>", return_path: 'daniel@codata.pb.gov.br'

  def welcome(recipient)
    @account = recipient
    mail(to: recipient,
         bcc: ["daniel@codata.pb.gov.br", "Order Watcher <daniel@codata.pb.gov.br>"],
         body: 'teste de email')
  end

  def sendmail(recipients, body, subject)
  	mail(to: recipients,
         bcc: ["Segurança da Informação Codata <daniel@codata.pb.gov.br>"],
         body: body,
  		 subject: subject).deliver
  end

end