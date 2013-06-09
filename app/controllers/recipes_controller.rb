class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :destroy, :edit, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
    if params[:tag]
      @recipes = Recipe.paginate(page: params[:page], per_page: 10).tagged_with(params[:tag])      
    else      
     @recipes = Recipe.paginate(page: params[:page], per_page: 5)
    end
  end

  def view_count
    @recipes = Recipe.paginate(page: params[:page], per_page: 10).view_count    # view_count scope
    render 'index'
  end

  def like_count
    @recipes = Recipe.paginate(page: params[:page], per_page: 10).like_count   # like_count scope
    render 'index'
  end

  def comment_count 
    @recipes = Recipe.paginate(page: params[:page], per_page: 10)
    render 'index'
  end

  def new_recipes
    @recipes = Recipe.paginate(page: params[:page], per_page: 10).new_items        # new recipes scope
    render 'index'
  end

  def begen
    @recipe = Recipe.find(params[:id])
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
    if current_user.ip_address != request.remote_ip
      current_user.ip_address = request.remote_ip
      @user = current_user
      @user.save
      @recipe.increment(:likes, by = 1)
      @recipe.save
      render 'index'      
    else
      render 'index'
    end
  end


  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])
    if user_signed_in? && current_user.ip_address != request.remote_ip
      current_user.ip_address = request.remote_ip
      @recipe.increment(:views, by = 1)
      @recipe.save
    end
    @commentable = @recipe
    @comments = @commentable.comments.paginate(page: params[:page], per_page: 2)
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


    def correct_user # 
      @recipe = Recipe.find(params[:id])
      @user = @recipe.user
      if current_user == @user
        true
      else
        redirect_to(root_path)
      end
    end
end
