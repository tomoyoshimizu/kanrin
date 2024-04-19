class Admin::UsersController < ApplicationController
  before_action :get_user_matched_id
  before_action :authenticate_admin!

  def index
    @search_word = params[:search_word] || ""
    @is_active = params[:is_active] || ""
    @users = User.desc
    @users = @users.valid if @is_active == "true"
    @users = @users.invalid if @is_active == "false"
    @users = @users.search(@search_word) if @search_word.present?
  end

  def freeze
    @user.update(is_active: params[:is_active])
    redirect_to request.referer
  end

  private
    def get_user_matched_id
      if params[:id]
        @user = User.find_by(id: params[:id])
        if @user.nil?
          redirect_to admin_users_path
        end
      end
    end
end
