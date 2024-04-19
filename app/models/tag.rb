class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :projects, through: :taggings

  scope :search, -> (word){ where("name LIKE?", "%#{word}%") }
end
