class AddParametersToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :query_type, :string
    add_reference :appointments, :dog, null: true, foreign_key: true
  end
end
