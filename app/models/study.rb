class Study < ActiveRecord::Base
  validates :name, presence: true
  validates :user_id, presence: true
  validates :active, presence: true
end