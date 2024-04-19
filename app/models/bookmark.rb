class Bookmark < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :project

  has_one :notification, as: :notifiable, dependent: :destroy
  
  scope :desc, -> { order(created_at: "DESC") }

  after_create do
    create_notification(user_id: project.user_id)
  end

  def notification_message
    "#{project.title}が#{user.name}さんにブックマークされました"
  end

  def notification_path
     user_path(user)
  end
end
