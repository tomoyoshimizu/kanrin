class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :projects, through: :taggings

  scope :usage,         -> { joins(:taggings).group(:tag_id).order("count(project_id) DESC") }
  scope :searched_with, -> (word){ where("name LIKE?", "%#{word}%") }
end
