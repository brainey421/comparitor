class Study < ActiveRecord::Base
  validates :name, presence: true
  validates :user_id, presence: true
  validates :n_way, presence: true
  validates :originator, presence: true
end