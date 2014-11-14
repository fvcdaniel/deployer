class AddUltimaAcaoAndUserAcaoToApp < ActiveRecord::Migration
  def change
    add_column :apps, :ultima_acao, :string
    add_column :apps, :user_acao, :string
  end
end
