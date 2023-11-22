class CreateWalkers < ActiveRecord::Migration[7.0]
  def change
    create_table :walkers do |t|
      t.string :name
      t.string :surname
      t.text :phoneNum
      t.string :email
      t.string :zone
      t.time :start
      t.time :end

      t.timestamps
    end

  end
end
