class ExpandCaregivers < ActiveRecord::Migration[7.0]
  def change
    add_column :caregivers, :zone, :string
    add_column :caregivers, :services, :string
  end
end
