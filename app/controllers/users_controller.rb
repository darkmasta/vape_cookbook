class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :destroy, :edit, :update]

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @commentable = @user
    @comments = @commentable.comments
    @comment = Comment.new
  end

  def index
    @users = User.all
  end

  def edit
  end


  def update
    respond_to do |format|
      if @user.update_without_password(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end 
    
  private
    
    def set_user
      @user = current_user
    end
    
    def user_params
      params.require(:user).permit(:email, :nick, :password, :pasword_confirmation)
    end
end
