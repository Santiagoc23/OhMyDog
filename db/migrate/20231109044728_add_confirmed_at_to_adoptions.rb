class AddConfirmedAtToAdoptions < ActiveRecord::Migration[7.0]
  def change
    add_column :adoptions, :confirmed_at, :DateTime
  end
end
