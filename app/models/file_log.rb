#encoding:utf-8
class FileLog
	attr_accessor :servidor, :file_path, :file_name, :tamanho, :server

	def teste
		Net::SSH.start(  '201.18.100.29', 'tomcat', {:port => 2229} ) do |ssh|
			@result = ssh.exec!('ls').split("\n")
		end
	end
end