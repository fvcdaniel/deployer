#encoding:utf-8
class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  belongs_to :user

  attr_accessible :file, :release_notes, :attachable_type, :attachable_id, :filename, :user_id, :user
  mount_uploader :file, FileUploader

  validates_presence_of :file, :release_notes, :user
  validates_format_of :file, :with => %r{\.(war|ear)$}i, :message => "não permitido, favor usar somente: WAR e EAR."

  def filename
  	File.basename(self.file.to_s)
  end

  def app
  	App.find(attachable_id)
  end
  
  def appservers
  	self.app.appservers
  end
end
