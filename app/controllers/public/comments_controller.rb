class Public::CommentsController < ApplicationController
  before_action :get_comment_matched_id
  before_action :authenticate_user!

  def create
    comment = current_user.comments.new(comment_params)
    comment.post_id = params[:post_id]
    @post = comment.post
    @new_comment = comment.save ? Comment.new : comment
    @comments = @post.comments.valid
    render "replace_comments"
  end

  def destroy
    @post = @comment.post
    @new_comment = Comment.new
    @comments = @post.comments.valid
    @comment.destroy
    render "replace_comments"
  end

  private
    def get_comment_matched_id
      if params[:id]
        @comment = Comment.find(params[:id])
        redirect_to posts_path if @comment.nil? || !@comment.user.is_active
      end
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
