class User < ApplicationRecord
  GUEST_USER_EMAIL = "guest@example.com"
  GUEST_USER_TELEPHONE_NUMBER = "00000000000"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :follow_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followees, through: :follow_relationships, source: :followee
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :followed_relationships, source: :follower
  has_many :projects, dependent: :destroy
  has_many :posts, through: :projects, source: :posts
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_projects, through: :bookmarks, source: :project
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  scope :valid,         -> { where(is_active: true) }
  scope :invalid,       -> { where(is_active: false) }
  scope :searched_with, -> (word) { where("name LIKE?", "%#{word}%") }
  scope :desc,          -> { order(created_at: "DESC") }

  has_one_attached :image

  validates :name, presence: true
  validates :email, presence: true
  validates :telephone_number, presence: true

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.telephone_number = GUEST_USER_TELEPHONE_NUMBER
    end
  end

  def is_guest_user?
    email == GUEST_USER_EMAIL
  end

  def has_follower?
    followers.valid.count > 0
  end

  def is_followed_by?(user)
    followers.include?(user)
  end

  def get_image(width, height)
    unless image.attached?
      image.attach(
        io: File.open(Rails.root.join("app/assets/images/user_placeholder.png")),
        filename: "user_placeholder.png",
        content_type: "image/png"
      )
    end
    image.variant(resize_to_fill: [width, height]).processed
  end
end
