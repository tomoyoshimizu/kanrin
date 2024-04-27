class Project < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :posts, dependent: :destroy

  scope :visible,       -> { where(visibility: 0) }
  scope :valid,         -> { joins(:user).where(user: {is_active: true}) }
  scope :searched_with, -> (word){ where("title LIKE?", "%#{word}%") }
  scope :desc,          -> { order(created_at: "DESC") }

  enum status: { in_progress: 0, completed: 1, pending: 2 }
  enum visibility: { visible: 0, hidden: 1 }

  validates :title, presence: true

  def is_completed?
    status.eql?("completed")
  end

  def is_visible?
    visibility.eql?("visible")
  end

  def is_bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def last_posted_at
    posts.last.created_at
  end

  def total_working_minutes
    posts.pluck(:working_minutes).compact.sum
  end

  def get_thumbnail(width, height)
    target = posts.desc.find { |post| post.image.attached? }
    if target.present?
      target.image.variant(resize_to_fill: [width, height]).processed
    else
      "post_placeholder"
    end
  end
end
