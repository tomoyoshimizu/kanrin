class Public::PostsController < ApplicationController
  before_action :get_post_matched_id
  before_action :authenticate_user!,        only: [:index, :create, :new, :edit, :update, :destroy]
  before_action :prohibited_illegal_access, only: [:edit, :update, :destroy]

  def index
    @posts = Post.visible.valid.posted_by(current_user.followees).desc
  end

  def create
    @new_post = Post.new(post_params)
    if @new_post.save
      @comments = @new_post.comments.valid
      redirect_to project_url(@new_post.project)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    project = Project.find_by(id: params[:project])
    if project && project.user == current_user
      @new_post = Post.new
      @new_post.project_id = params[:project]
    else
      redirect_to projects_url
    end
  end

  def edit
  end

  def show
    @new_comment = Comment.new
    @comments = @post.comments.valid
  end

  def update
    if @post.update(post_params)
      @comments = @post.comments.valid
      redirect_to post_url(@post)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    parent_project = @post.project
    @post.destroy
    redirect_to project_path(parent_project)
  end

  private
    def get_post_matched_id
      if params[:id]
        @post = Post.find(params[:id])
        if @post.nil?
          redirect_to posts_path
        end
        unless admin_signed_in? || @post.user.is_active
          redirect_to posts_path
        end
      end
    end

    def prohibited_illegal_access
      unless current_user == @post.user
        redirect_to user_path(current_user)
      end
    end

    def post_params
      params.require(:post).permit(:project_id, :body, :working_minutes, :image)
    end
end
