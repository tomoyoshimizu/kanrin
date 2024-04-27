class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(is_read: false) }
  scope :desc,  -> { order(created_at: "DESC") }

  def message
    notifiable.notification_message
  end

  def notifiable_path
    notifiable.notification_path
  end

  def notifiable_user
    notifiable.notification_user
  end
end
