class Comment < ApplicationRecord
  include Notifiable

  belongs_to :post
  belongs_to :user

  has_one :project, through: :post, source: :project
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :body, presence: true

  scope :valid, -> { joins(:user).where(user: { is_active: true }) }

  after_create do
    create_notification(user_id: self.project.user_id) unless self.user_id.eql?(self.project.user_id)
  end

  def notification_message
    "#{self.project.title}の投稿に#{self.user.name}さんがコメントしました"
  end

  def notification_path
    post_path(self.post)
  end

  def notification_user
    self.user
  end
end
