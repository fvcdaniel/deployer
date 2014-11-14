class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :nome
      t.string :link
      t.belongs_to :secretaria
      t.belongs_to :appserver

      t.timestamps
    end
    add_index :apps, :secretaria_id
  end
end
