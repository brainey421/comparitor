class User < ActiveRecord::Base
  validates :email, presence: true
  validates :guid, presence: true
end