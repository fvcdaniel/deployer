class CreateAppsUsers < ActiveRecord::Migration
  def change
    create_table :apps_users, :id => false do |t|
      t.integer :app_id
      t.integer :user_id
      
    end
  end
end
