class CreateMissingPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :missing_posts do |t|
      t.string :name
      t.integer :age
      t.string :size
      t.string :gender
      t.string :breed
      t.string :zone
      t.string :description
      t.boolean :finished, default: false
      t.datetime :confirmed_at
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
