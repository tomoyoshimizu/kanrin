class Admin::UsersController < ApplicationController
  before_action :get_user_matched_id
  before_action :authenticate_admin!

  def index
    @search_word = params[:search_word] || ""
    @is_active = params[:is_active] || ""
    scoped_users = case @is_active
                   when "true"  then User.desc.valid
                   when "false" then User.desc.invalid
                   else User.desc
                   end
    scoped_users = scoped_users.searched_with(@search_word) if @search_word.present?
    @users = scoped_users.page(params[:page]).per(6)
  end

  def freeze
    @user.update(is_active: params[:is_active])
    redirect_to request.referer
  end

  private
    def get_user_matched_id
      if params[:id]
        @user = User.find_by(id: params[:id])
        redirect_to admin_users_path if @user.nil?
      end
    end
end
