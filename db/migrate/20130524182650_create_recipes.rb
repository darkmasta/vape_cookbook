class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :instruction
      t.text :description
      t.integer :likes
      t.string :category
      t.integer :user_id

      t.timestamps
    end
  end
end
