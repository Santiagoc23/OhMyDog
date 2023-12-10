class AddDescripcionToVacunas < ActiveRecord::Migration[7.0]
  def change
    add_column :vacunas, :description, :text
  end
end
