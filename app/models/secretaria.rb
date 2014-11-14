class Secretaria < ActiveRecord::Base
  attr_accessible :abreviatura, :link, :nome
  has_many :apps
  
  def name
  	self.nome
  end

end
