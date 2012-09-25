class Reason < ActiveRecord::Base
  has_many :carts
  validates :content, presence: true, uniqueness: true
  attr_accessible :content
end
