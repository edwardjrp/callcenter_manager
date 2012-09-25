class Reason < ActiveRecord::Base
  has_many :carts
  validates :description, presence: true, uniqueness: true
  attr_accessible :description
end
