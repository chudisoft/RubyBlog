class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :find_user

  def new
    @post = Post.find(params[:post_id])
    @user = User.find(params[:user_id])
    @comment = @post.comments.new
  end

  def create
    @post = Post.find(params[:post_id])
    # pp @post
    # @comment = @post.comments.new(comment_params)
    @comment = Comment.new(comment_params)
    @comment.post = @post
    @comment.user = current_user
    @user = User.find(params[:user_id])

    if @comment.save
      flash[:notice] = 'Comment created successfully.'
      redirect_to user_post_path(@user, @post)
    else
      puts "Comment not saved. Errors: #{comment.errors.full_messages}" # Add this line for debugging
      render 'new'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    # Authorization check
    authorize! :destroy, @comment

    @comment.destroy
    redirect_back(fallback_location: user_post_path(@user, params[:post_id]),
                  notice: 'Comment was successfully removed.')
  end

  private

  def find_user
    @user = current_user
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
