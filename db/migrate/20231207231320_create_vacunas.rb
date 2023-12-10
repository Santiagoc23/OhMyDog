class CreateVacunas < ActiveRecord::Migration[7.0]
  def change
    create_table :vacunas do |t|
      t.references :dog, foreign_key: true
      t.date :fechaAct
      t.text :tipoVacuna
      t.integer :peso
      t.text :enfermedad
      t.integer :dosis
      t.text :medicacion
      t.date :fechaProx

      t.timestamps
    end
  end
end
