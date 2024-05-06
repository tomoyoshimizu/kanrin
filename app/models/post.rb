class Post < ApplicationRecord
  belongs_to :project
  has_one :user, through: :project
  has_one :safe_seaech_detection, dependent: :destroy

  has_many :comments, dependent: :destroy

  scope :visible,   -> { joins(:project).where(project: { visibility: 0 }) }
  scope :valid,     -> { joins(:user).where(user: { is_active: true }) }
  scope :posted_by, -> (user) { where(user: user) }
  scope :desc,      -> { order(created_at: "DESC") }

  has_one_attached :image

  validates :body, presence: true

  def get_image(width, height)
    image.variant(resize_to_limit: [width, height]).processed
  end

  def attach_safe_seaech_detection(params)
    if safe_seaech_detection.present?
      safe_seaech_detection.update(params)
    else
      create_safe_seaech_detection(params)
    end
  end

  def detach_safe_seaech_detection
    return unless safe_seaech_detection.present?
    safe_seaech_detection.destroy
    reload_safe_seaech_detection
  end
end
