class AddAgeToAdoptions < ActiveRecord::Migration[7.0]
  def change
    add_column :adoptions, :age, :string
  end
end
