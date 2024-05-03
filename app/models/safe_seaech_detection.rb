class SafeSeaechDetection < ApplicationRecord
  belongs_to :post

  likelihood = { UNKNOWN: 0, VERY_UNLIKELY: 1, UNLIKELY: 2, POSSIBLE: 3, LIKELY: 4, VERY_LIKELY: 5 }

  enum adult:    likelihood, _prefix: true
  enum spoof:    likelihood, _prefix: true
  enum medical:  likelihood, _prefix: true
  enum violence: likelihood, _prefix: true
  enum racy:     likelihood, _prefix: true
end
