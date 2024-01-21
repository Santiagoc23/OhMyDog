class CreateAdoptions < ActiveRecord::Migration[7.0]
  def change
    create_table :adoptions do |t|
      t.string :name
      t.string :race
      t.string :size
      t.string :sex
      t.text :description
      t.text :situation
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
