class CreateHealthRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :health_records do |t|

      t.timestamps
    end
  end
end
