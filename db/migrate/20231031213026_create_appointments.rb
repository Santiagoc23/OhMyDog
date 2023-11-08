class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.datetime :time
      t.integer :state, default: "0"
      # 0= pendiente de confirmacion, 1= confirmado, 2= en reprogramación (desde user), 3= en reprogramacion (desde vt), 4= cancelado
      t.text :message, default:""
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
