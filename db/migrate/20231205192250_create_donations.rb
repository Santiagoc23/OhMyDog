class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.string :title
      t.text :description
      t.date :closing_date
      t.decimal :target_amount
      t.decimal :amount

      t.timestamps
    end
  end
end
