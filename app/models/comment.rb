class Comment < ApplicationRecord
  include Notifiable

  belongs_to :post
  belongs_to :project, through: :post, source: :project
  belongs_to :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true

  after_create do
    create_notification(user_id: post.user_id)
  end

  def notification_message
    "#{project.title}の投稿に#{user.name}さんがコメントしました"
  end

  def notification_path
    post_path(post)
  end
end
