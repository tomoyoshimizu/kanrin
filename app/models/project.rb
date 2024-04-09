class Project < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :posts, dependent: :destroy

  enum status: { in_progress: 0, completed: 1, pending: 2 }
  enum visibility: { visible: 0, hidden: 1 }

  validates :title, presence: true

  def is_bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def latest_post
    posts.order(updated_at: :desc).first
  end

  def self.get_thumbnail(project)
    target = project.posts.order(created_at: :desc).find { |post| post.image.attached? }
    if target.nil?
      "https://placehold.jp/640x360.png"
    else
      target.image.variant(resize_to_fill: [640, 360]).processed
    end
  end
end
