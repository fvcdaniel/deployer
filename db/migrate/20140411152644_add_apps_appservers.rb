class AddAppsAppservers < ActiveRecord::Migration
  def up
  	create_table 'apps_appservers', :id => false do |t|
		t.column :app_id, :integer
		t.column :appserver_id, :integer
	end
  end

  def down
  	drop_table 'apps_appservers'
  end
end
