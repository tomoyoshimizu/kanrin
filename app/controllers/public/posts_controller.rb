class Public::PostsController < ApplicationController
  if Rails.env.development? || Rails.env.test?
    ActiveStorage::AnalyzeJob.queue_adapter = :inline
    ActiveStorage::PurgeJob.queue_adapter = :inline
  end

  before_action :get_post_matched_id
  before_action :authenticate_user!,                only: [:index, :create, :new, :edit, :update, :destroy]
  before_action :prohibit_illegal_access,           only: [:edit, :update, :destroy]
  before_action :prohibit_access_to_hidden_project, only: [:show]

  def index
    @posts = Post.visible.valid.posted_by(current_user.followees).desc.page(params[:page]).per(6)
  end

  def create
    @new_post = Post.new(post_params)
    if @new_post.save
      @comments = @new_post.comments.valid
      if params[:post][:confirm_alert] == "1"
        @new_post.attach_safe_seaech_detection(safe_seaech_detection_params)
      end
      redirect_to project_url(@new_post.project)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    project = Project.find_by(id: params[:project])
    if project.present? && project.user == current_user
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
      if params[:post][:confirm_alert] == "1"
        @post.attach_safe_seaech_detection(safe_seaech_detection_params)
      else
        @post.detach_safe_seaech_detection
      end
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

  def send_api
    result = Vision.get_image_data(params[:requests])
    render json: result
  end

  private
    def get_post_matched_id
      if params[:id]
        @post = Post.find(params[:id])
        redirect_to posts_path if @post.nil?
        redirect_to posts_path unless admin_signed_in? || @post.user.is_active
      end
    end

    def prohibit_illegal_access
      redirect_to user_path(current_user) unless @post.user == current_user
    end

    def prohibit_access_to_hidden_project
      if @post.project.visibility == "hidden"
        redirect_to posts_path unless admin_signed_in? || @post.user == current_user
      end
    end

    def post_params
      params.require(:post).permit(:project_id, :body, :working_minutes, :image)
    end

    def safe_seaech_detection_params
      params.require(:post).dig(:safe_seaech_detection).permit(:adult, :spoof, :medical, :violence, :racy)
    end
end
