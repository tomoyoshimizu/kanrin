class Public::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def followings
    @user = user_matched_id
  end

  def followers
    @user = user_matched_id
  end

  def bookmarks
    @user = user_matched_id
  end

  def notifications
  end

  def edit
    @user = user_matched_id
  end

  def show
    @user = user_matched_id
  end

  def update
    user = user_matched_id
    if user.update(user_params)
      redirect_to user_path(user)#, notice: "User was successfully updated."
    else
      @user = user
      render :edit, status: :unprocessable_entity
    end
  end

  def withdraw
    user = current_user
    withdrew_email = "withdrew_" + Time.now.to_i.to_s + user.email
    user.update(email: withdrew_email, is_active: false)
    reset_session
    redirect_to root_path
  end

  def destroy
    project_matched_id.destroy
    reset_session
    redirect_to root_path
  end

  private
    def user_matched_id
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :description, :image, :email, :telephone_number)
    end
end
