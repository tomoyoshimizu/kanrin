class Post < ApplicationRecord
  belongs_to :project
  has_one :user, through: :project

  has_many :comments, dependent: :destroy

  scope :visible,   -> { joins(:project).where(project: { visibility: 0 }) }
  scope :valid,     -> { joins(:user).where(user: { is_active: true }) }
  scope :posted_by, -> (user) { where(user: user) }
  scope :desc,      -> { order(created_at: "DESC") }

  has_one_attached :image

  validates :body, presence: true

  def get_image(width, height)
    if image.attached?
      image.variant(resize_to_limit: [640, 360]).processed
    else
      "post_placeholder"
    end
  end
end
