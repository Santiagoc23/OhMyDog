class AddUsersToWalkers < ActiveRecord::Migration[7.0]
  def change
    add_reference :walkers, :user, foreign_key: true
  end
end
