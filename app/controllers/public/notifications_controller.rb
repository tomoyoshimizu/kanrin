class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def update
    notification = current_user.notifications.find_by(id: params[:id])
    if notification
      notification.update(is_read: true)
      redirect_to notification.notifiable_path
    end
  end
end
