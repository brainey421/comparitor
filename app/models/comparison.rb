class Comparison < ActiveRecord::Base
  validates :user_id, presence: true
  validates :study_id, presence: true
  validates :time, presence: true
end