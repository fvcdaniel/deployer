class Appserver < ActiveRecord::Base
  attr_accessible :dpath, :duser, :ip, :path, :port, :servidor, :type
  has_and_belongs_to_many :apps

  def name
  	"#{self.servidor} - #{self.ip}".upcase
  end

  def tomcat?
  	self.servidor.upcase == 'TOMCAT'
  end

  def jboss?
  	self.servidor.upcase == 'JBOSS'
  end
  
end
