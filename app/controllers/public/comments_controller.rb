class Public::CommentsController < ApplicationController
  def create
    comment = current_user.comments.new(comment_params)
    comment.post_id = params[:post_id]
    @post = comment.post
    @new_comment = comment.save ? Comment.new : comment
    render "replace_comments"#, notice: "Comment was successfully created."
  end

  def edit
  end

  def update
  end

  def destroy
    comment = comment_matched_id
    comment.destroy
    @post = comment.post
    @new_comment = Comment.new
    render "replace_comments"#, notice: "Comment was successfully destroyed."
  end

  private
    def comment_matched_id
      Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
