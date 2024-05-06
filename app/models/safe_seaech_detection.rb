class SafeSeaechDetection < ApplicationRecord
  belongs_to :post
  has_one :user, through: :post, source: :user

  scope :desc,  -> { order(created_at: "DESC") }
  scope :valid, -> { joins(:user).where(user: { is_active: true }) }

  likelihood = { UNKNOWN: 0, VERY_UNLIKELY: 1, UNLIKELY: 2, POSSIBLE: 3, LIKELY: 4, VERY_LIKELY: 5 }

  enum adult:    likelihood, _prefix: true
  enum spoof:    likelihood, _prefix: true
  enum medical:  likelihood, _prefix: true
  enum violence: likelihood, _prefix: true
  enum racy:     likelihood, _prefix: true
end
