class AddTypeToAppserver < ActiveRecord::Migration
  def change
    add_column :appservers, :type, :string
  end
end
