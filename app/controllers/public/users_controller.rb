class Public::UsersController < ApplicationController
  before_action :get_user_matched_id
  before_action :authenticate_user!,         only: [:followers, :notifications, :edit, :update, :destroy]
  before_action :prohibit_illegal_access,    only: [:followers, :notifications, :edit, :update, :destroy]
  before_action :prohibit_guest_user_access, only: [:edit, :update, :destroy]

  def index
    @search_word = params[:search_word] || ""
    scoped_users = User.valid.desc
    scoped_users = scoped_users.searched_with(@search_word) if @search_word.present?
    @users = scoped_users.page(params[:page]).per(6)
    @count = scoped_users.length
  end

  def followees
    @users = @user.followees.valid.desc.page(params[:page]).per(6)
  end

  def followers
    @users = @user.followers.valid.desc.page(params[:page]).per(6)
    redirect_to user_path(@user) unless @users.present?
  end

  def bookmarks
    scoped_projects = @user.bookmark_projects.visible.valid.desc
    @projects = scoped_projects.page(params[:page]).per(6)
  end

  def notifications
    @notifications = current_user.notifications.unread.desc.page(params[:page]).per(6)
  end

  def edit; end

  def show
    scoped_projects = @user.projects.desc
    scoped_projects = scoped_projects.visible unless admin_signed_in? || @user == current_user
    @projects = scoped_projects.page(params[:page]).per(6)
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
        redirect_to users_path if @user.nil?
        redirect_to users_path unless admin_signed_in? || @user.is_active
      end
    end

    def prohibit_illegal_access
      redirect_to user_path(current_user) unless @user == current_user
    end

    def prohibit_guest_user_access
      redirect_to user_path(current_user) if @user.is_guest_user?
    end

    def user_params
      params.require(:user).permit(:name, :description, :image, :email, :telephone_number)
    end
end
