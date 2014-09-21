class Member < ActiveRecord::Base
  validates :category_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :link, presence: true
end