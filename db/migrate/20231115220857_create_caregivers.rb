class CreateCaregivers < ActiveRecord::Migration[7.0]
  def change
    create_table :caregivers do |t|
      t.string :name
      t.string :surname
      t.text :phoneNum
      t.string :email

      t.timestamps
    end
  end
end
