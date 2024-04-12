class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :prohibited_illegal_access, only: [:edit, :update, :destroy]

  def index
    @post = Post.all
  end

  def create
    post = Post.new(post_params)
    if post.save
      redirect_to project_url(post.project)#, notice: "Post was successfully created."
    else
      @new_post = post
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @new_post = Post.new
    @new_post.project_id = params[:project]
  end

  def edit
    @post = post_matched_id
  end

  def show
    @post = post_matched_id
    @new_comment = Comment.new
  end

  def update
    post = post_matched_id
    if post.update(post_params)
      redirect_to post_url(post)#, notice: "Post was successfully updated."
    else
      @post = post
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project = post_matched_id.project
    post_matched_id.destroy
    redirect_to project_path(project)#, notice: "Post was successfully destroyed."
  end

  private
    def post_matched_id
      Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:project_id, :body, :working_minutes, :image)
    end

    def prohibited_illegal_access
      unless current_user == post_matched_id.user
        redirect_to user_path(current_user)
      end
    end
end
