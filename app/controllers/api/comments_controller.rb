module Api
  class CommentsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      post = Post.find(params[:post_id])
      comments = post.comments
      render json: comments
    end

    def create
      post = Post.find(params[:post_id])
      comment = Comment.new(comment_params)
      comment.post_id = post.id
      comment.user_id = post.author_id

      if comment.save
        render json: comment, status: :created
      else
        Rails.logger.info comment.errors.full_messages.to_sentence
        render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:text)
    end
  end
end
