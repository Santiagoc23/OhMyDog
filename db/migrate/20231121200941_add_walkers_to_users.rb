class AddWalkersToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :walker, foreign_key: true
  end
end
