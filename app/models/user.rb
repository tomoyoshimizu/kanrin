class User < ApplicationRecord
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

  scope :is_active, -> (boolean = true){ where(is_active: boolean) }
  scope :search, -> (word){ where("name LIKE?", "%#{word}%") }
  scope :desc, -> { order(created_at: "DESC") }

  has_one_attached :image

  validates :name, presence: true
  validates :email, presence: true
  validates :telephone_number, presence: true

  def get_image(width, height)
    unless image.attached?
      image.attach(
        io: File.open(Rails.root.join("app/assets/images/user_placeholder.jpg")),
        filename: "user_placeholder.jpg",
        content_type: "image/jpeg"
      )
    end
    image.variant(resize_to_fill: [width, height]).processed
  end

  def is_followed_by?(user)
    followers.include?(user)
  end
end
