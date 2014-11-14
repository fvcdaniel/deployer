class FixColumnNameTipoToServidor < ActiveRecord::Migration
  def up
  	rename_column :appservers, :tipo, :servidor
  end

  def down
  	rename_column :appservers, :servidor, :tipo
  end
end
