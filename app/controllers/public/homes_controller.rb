class Public::HomesController < ApplicationController
  before_action :redirect_admin, if: :admin_signed_in?

  def top
  end

  def about
  end

  private
    def redirect_admin
      redirect_to admin_root_path
    end
end
