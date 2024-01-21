class AddParametersToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :surname, :string, null: false, default: ""
    add_column :users, :phoneNum, :text
    add_column :users, :dni, :string, null: false, default: ""
    add_index :users, :dni, unique: true
    add_column :users, :firstLogin, :boolean, default: true
  end
end
