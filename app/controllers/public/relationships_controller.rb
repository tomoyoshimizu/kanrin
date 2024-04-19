class Public::RelationshipsController < ApplicationController
  before_action :get_user_matched_id
  before_action :authenticate_user!

  def create
    Relationship.create(follower_id: current_user.id, followee_id: @user.id)
    redirect_to request.referer
  end

  def destroy
    Relationship.find_by(follower_id: current_user.id, followee_id: @user.id).destroy
    redirect_to request.referer
  end

  private
    def get_user_matched_id
      if params[:user_id]
        @user = User.find_by(id: params[:user_id])
        if @user.nil? || !@user.is_active
          redirect_to users_path
        end
      end
    end
end
