class Public::HomesController < ApplicationController
  before_action :redirect_signed_in_user

  def top
  end

  def about
  end

  private
    def redirect_signed_in_user
      if user_signed_in?
        redirect_to posts_path
      end
      if admin_signed_in?
        redirect_to admin_root_path
      end
    end
end
