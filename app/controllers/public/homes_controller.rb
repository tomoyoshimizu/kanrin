class Public::HomesController < ApplicationController
  before_action :redirect_signed_in_user

  def top
  end

  def about
  end

  private
    def redirect_signed_in_user
      redirect_to user_path(current_user) if user_signed_in?
      redirect_to admin_root_path if admin_signed_in?
    end
end
