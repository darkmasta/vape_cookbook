json.array!(@recipes) do |recipe|
  json.extract! recipe, :name, :instruction, :description, :likes, :category, :user_id
  json.url recipe_url(recipe, format: :json)
end