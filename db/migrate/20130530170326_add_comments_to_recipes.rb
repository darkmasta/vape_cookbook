class AddCommentsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :comments, :integer
  end
end
