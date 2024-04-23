class Relationship < ApplicationRecord
  include Notifiable

  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  has_one :notification, as: :notifiable, dependent: :destroy

  after_create do
    create_notification(user_id: followee.id)
  end

  def notification_message
    "#{follower.name}さんにフォローされました"
  end

  def notification_path
    user_path(follower)
  end

  def notification_user
    self.follower
  end
end
