class AddImageToMissingPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :missing_posts, :image, :string
  end
end
