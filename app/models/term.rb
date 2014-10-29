class Term < ActiveRecord::Base
  validates :terms, presence: true
end