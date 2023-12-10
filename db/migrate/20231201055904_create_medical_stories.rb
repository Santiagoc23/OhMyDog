class CreateMedicalStories < ActiveRecord::Migration[7.0]
  def change
    create_table :medical_stories do |t|

      t.timestamps
    end
  end
end
