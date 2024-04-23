class Public::UsersController < ApplicationController
  before_action :get_user_matched_id
  before_action :authenticate_user!,         only: [:followers, :notifications, :edit, :update, :destroy]
  before_action :prohibit_illegal_access,    only: [:followers, :notifications, :edit, :update, :destroy]
  before_action :prohibit_guest_user_access, only: [:edit, :update, :destroy]

  def index
    @search_word = params[:search_word] || ""
    @users = User.valid.desc
    @users = @users.search(@search_word) if @search_word.present?
    @count = @users.count
  end

  def followees
    @users = @user.followees.valid.desc
  end

  def followers
    @users = @user.followers.valid.desc
    unless @users.present?
      redirect_to user_path(@user)
    end
  end

  def bookmarks
    scoped_projects = @user.bookmark_projects.visible.valid
    @projects = Project.sort_last_posted(scoped_projects)
  end

  def notifications
    @notifications = current_user.notifications.unread.desc
  end

  def edit
  end

  def show
    scoped_projects = @user.projects
    scoped_projects = scoped_projects.visible unless current_user == @user
    @projects = Project.sort_last_posted(scoped_projects)
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      @user = user
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private
    def get_user_matched_id
      if params[:id]
        @user = User.find_by(id: params[:id])
        if @user.nil?
          redirect_to users_path
        end
        unless admin_signed_in? || @user.is_active
          redirect_to users_path
        end
      end
    end

    def prohibit_illegal_access
      unless current_user == @user
        redirect_to user_path(current_user)
      end
    end

    def prohibit_guest_user_access
      if @user.guest_user?
        redirect_to user_path(current_user)
      end
    end

    def user_params
      params.require(:user).permit(:name, :description, :image, :email, :telephone_number)
    end
end
