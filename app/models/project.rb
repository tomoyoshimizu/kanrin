class Project < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :posts, dependent: :destroy

  scope :visible, -> { where(visibility: 0) }
  scope :valid,   -> { joins(:user).where(user: {is_active: true}) }
  scope :search,  -> (word){ where("title LIKE?", "%#{word}%") }
  scope :desc,    -> { order(created_at: "DESC") }

  enum status: { in_progress: 0, completed: 1, pending: 2 }
  enum visibility: { visible: 0, hidden: 1 }

  validates :title, presence: true

  def is_bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def last_posted_at
    target = posts.desc.first
    if target.present?
      target.created_at
    else
      created_at
    end
  end

  def self.sort_last_posted(projects)
    projects.sort_by{|project| project.last_posted_at }.reverse
  end

  def self.get_thumbnail(project)
    target = project.posts.desc.find { |post| post.image.attached? }
    if target.present?
      target.image.variant(resize_to_fill: [640, 360]).processed
    else
      "https://placehold.jp/640x360.png"
    end
  end
end
