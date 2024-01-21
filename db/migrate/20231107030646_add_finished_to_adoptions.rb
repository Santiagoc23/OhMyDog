class AddFinishedToAdoptions < ActiveRecord::Migration[7.0]
  def change
    add_column :adoptions, :finished, :boolean, deafult:false
  end
end
