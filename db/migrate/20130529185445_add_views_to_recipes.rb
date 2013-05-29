class AddViewsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :views, :integer
  end
end
