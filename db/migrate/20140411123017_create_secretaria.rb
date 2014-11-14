class CreateSecretaria < ActiveRecord::Migration
  def change
    create_table :secretaria do |t|
      t.string :nome
      t.string :abreviatura
      t.string :link

      t.timestamps
    end
  end
end
