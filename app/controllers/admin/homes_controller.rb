class Admin::HomesController < ApplicationController
  def top
    redirect_to admin_users_path
  end
end
