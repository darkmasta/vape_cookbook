class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :recipes, :comments, :comments_count
  end
end
