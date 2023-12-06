class CreateUserCaregiverJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :reported_caregivers do |t|
      t.references :user, foreign_key: true
      t.references :caregiver, foreign_key: true

      t.timestamps
    end
  end
end
