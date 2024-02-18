class RecipesController < ApplicationController
  before_action :set_recipe, only: [:like, :show, :update, :destroy]
  before_action :authenticate_request, except: [:index, :show] # Skip authentication for index
  before_action :check_ownership, only: [:update, :destroy]


  def index
    @recipes = Recipe.all
    recipes_with_extra_info = @recipes.map do |recipe|
      recipe.as_json.merge({
                             is_owner: current_user.present? && current_user == recipe.user,
                             likes: recipe.likes.length,
                             comments_count: recipe.comments_count
                           })
    end

    render json: recipes_with_extra_info
  end

  def show
    command = OptionalUserIdentification.call(request.headers)
    recipe = Recipe.find(params[:id])
    recipe.increment!(:views)
    is_owner = command.success? && command.result == recipe.user

    comments = recipe.comments.includes(:user).map do |comment|
      {
        content: comment.content,
        created_at: comment.created_at,
        user_email: comment.user.email
      }
    end

    render json: recipe.as_json.merge(
      is_owner: is_owner,
      likes: recipe.likes.count,
      comments_count: recipe.comments.count,
      comments: comments
    )
  end


  # POST /recipes
  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      render json: @recipe, status: :created, location: @recipe
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def update
    if @recipe.update(recipe_params)
      render json: @recipe
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    head :no_content
  end

  def like
    return render json: { error: 'You must be logged in to like recipes.' }, status: :unauthorized unless current_user

    like = @recipe.likes.build(user: current_user)

    if like.save
      render json: { likes: @recipe.likes.count }
    else
      render json: { error: 'You can only like a recipe once.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Recipe not found" }, status: :not_found
  end


  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :instruction, :description)
  end

  def check_ownership
    recipe = Recipe.find(params[:id])
    render json: { error: 'Not Authorized' }, status: :unauthorized unless current_user == recipe.user
  end
end
