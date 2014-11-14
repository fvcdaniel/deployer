class Role < ActiveRecord::Base
  # attr_accessible :title, :body

  attr_accessible :name, :users, :user_ids
  
  has_and_belongs_to_many :users
end
