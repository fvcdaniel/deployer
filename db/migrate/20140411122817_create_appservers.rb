class CreateAppservers < ActiveRecord::Migration
  def change
    create_table :appservers do |t|
      t.string :ip
      t.integer :port
      t.string :path
      t.string :dpath
      t.string :tipo
      t.string :duser

      t.timestamps
    end
  end
end
