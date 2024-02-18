class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    puts "Comment params: #{comment_params}"
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created, location: [@commentable, @comment]
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    @commentable = Recipe.find(params[:recipe_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
