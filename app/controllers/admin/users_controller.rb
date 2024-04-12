class Admin::UsersController < ApplicationController
  def index
    @search_word = params[:search_word] || ""
    @is_active = params[:is_active] || ""
    users = User.all
    users = users.is_active(@is_active) if @is_active.present?
    users = users.search(@search_word) if @search_word.present?
    @users = users.desc
  end

  def freeze
    user = User.find(params[:id])
    user.update(is_active: params[:is_active])
    redirect_to request.referer
  end
end
