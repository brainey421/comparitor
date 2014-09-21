class Item < ActiveRecord::Base
  validates :study_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
end