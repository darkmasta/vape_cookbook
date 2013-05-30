class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :destroy, :edit, :update]

  # GET /recipes
  # GET /recipes.json
  def index
    if params[:tag]
      @recipes = Recipe.tagged_with(params[:tag])      
    else
      if user_signed_in?
        current_user.ip_address = request.remote_ip
        current_user.save
        @recipes = Recipe.all
      else
        @recipes = Recipe.all
      end 
    end
  end

  def view_count
    @recipes = Recipe.all.view_count    # view_count scope
    render 'index'
  end

  def like_count
    @recipes = Recipe.all.like_count   # like_count scope
    render 'index'
  end

  def comment_count 
    @recipes = Recipe.all
    render 'index'
  end

  def new_recipes
    @recipes = Recipe.new_items        # new recipes scope
    render 'index'
  end


  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])
    if user_signed_in? && current_user.ip_address != request.remote_ip 
      @recipe.views += 1
      @recipe.save
    end
    @commentable = @recipe
    @comments = @commentable.comments
    @comment = Comment.new
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = current_user.recipes.build(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render action: 'show', status: :created, location: @recipe }
      else
        format.html { render action: 'new' }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:name, :instruction, :description, :likes, :category, :tag_list, :views)
    end
end
