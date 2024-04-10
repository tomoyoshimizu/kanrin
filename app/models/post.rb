class Post < ApplicationRecord
  belongs_to :project
  has_one :user, through: :project

  has_many :comments, dependent: :destroy

  has_one_attached :image

  validates :body, presence: true
end
