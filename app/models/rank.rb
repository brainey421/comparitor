class Rank < ActiveRecord::Base
  validates :comparison_id, presence: true
  validates :item_id, presence: true
  validates :rank, presence: true
end