class CreateUserWalkerJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :reported_walkers do |t|
      t.references :user, foreign_key: true
      t.references :walker, foreign_key: true

      t.timestamps
    end
  end
end
