class CommentsController < ApplicationController
  before_action :load_commentable

  def index
    @comments = @commentable.comments.paginate(page: params[:page], per_page: 2)
  end

  def new
    @comment = @commentable.comments.new  
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id    # This line for tracking who is writing the comment
    if @comment.save
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end

  private
    def load_commentable
      # resource, id = request.path.split('/')[1, 2]    # 
      # @commentable = resource.singularize.classify.constantize.find(id)
    
      klass = [User, Recipe].detect { |c| params["#{c.name.underscore}_id"]}
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
