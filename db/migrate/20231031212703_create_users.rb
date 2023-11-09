class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :lastname
      t.integer :dni
      t.integer :phone
      t.string :mail

      t.timestamps
    end
  end
end
