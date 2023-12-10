class AddDogIdToVacunas < ActiveRecord::Migration[6.0]
  def change
    add_reference :vacunas, :dog, foreign_key: true
  end
end