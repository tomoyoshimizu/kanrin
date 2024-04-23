# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :prohibit_multiple_login, if: :admin_signed_in?
  before_action :is_active?, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def prohibit_multiple_login
    redirect_to admin_root_path
  end

  def is_active?
    @user = User.find_by(email: params[:user][:email])
    return unless @user && @user.valid_password?(params[:user][:password]) && !@user.is_active
    redirect_to user_session_path, alert: "このアカウントは停止されています"
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user)
  end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end
end
