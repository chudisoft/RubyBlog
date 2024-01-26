class PostsController < ApplicationController
  # Index action to list all posts
  def index
    @user = User.find(params[:user_id])
    # Preloads the comments and likes for each post to avoid N+1 queries
    @posts = @user.posts.includes(:comments, :likes).order(created_at: :desc).paginate(page: params[:page],
                                                                                       per_page: 10)
  end

  # Show action to display a single post for a specific user
  def show
    @user = User.find(params[:user_id])
    @post = @user.posts.find(params[:id])
  end

  # New action to display the post creation form
  def new
    @user = User.find(params[:user_id])
    @post = Post.new
  end

  # Create action to handle post creation
  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    @post.likes_counter = 0
    @post.comments_counter = 0
    if @post.save
      @user = User.find(params[:user_id])
      redirect_to user_post_path(@user, @post), notice: 'Post was successfully created.'
    else

      pp @post.errors
      pp @post.errors.full_messages
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  # Edit action to display the post edit form
  def edit
    @post = Post.find(params[:id])
  end

  # Update action to handle post updates
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render 'edit'
    end
  end

  # Destroy action to delete a post
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
