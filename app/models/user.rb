#encoding:utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :apps
  has_and_belongs_to_many :roles

  has_many :attachments

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :app_ids
  attr_accessible :apps, :apps_attributes, :attachments

  accepts_nested_attributes_for :apps

  validate :email_must_belongs_to_codata

  def email_must_belongs_to_codata
    unless self.email.end_with? 'codata.pb.gov.br'
      errors.add(:email, ('não permitido.'))
    end
  end

  def name
  	"#{self.email}".upcase
  end

  def role?(role)
      return !!self.roles.find_by_name(role.to_s.camelize)
  end
  
end
