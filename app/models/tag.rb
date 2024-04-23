class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :projects, through: :taggings

  scope :search, -> (word){ where("name LIKE?", "%#{word}%") }

  def self.usage(tags)
    tags.sort_by{|tag| tag.projects.count }.reverse
  end
end
