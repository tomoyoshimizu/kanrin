class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    Relationship.create(follower_id: current_user.id, followee_id: user.id)
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    Relationship.find_by(follower_id: current_user.id, followee_id: user.id).destroy
    redirect_to request.referer
  end
end
