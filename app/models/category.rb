# == Schema Information
#
# Table name: categories
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  has_options  :boolean          default(FALSE)
#  type_unit    :boolean          default(FALSE)
#  multi        :boolean          default(FALSE)
#  hidden       :boolean          default(FALSE)
#  base_product :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Category < ActiveRecord::Base
  validates :name, :presence=> true, :uniqueness=> true
  before_validation :has_modifiers_when_manage_units
  has_many :products
  attr_accessible :base_product, :has_options, :hidden, :multi, :name, :unit_type
  
  
  
  
  private
    def has_modifiers_when_manage_units
      if has_options == false 
        errors.add(:has_options, "La categoria no tiene complementos") if type_unit == true
      end
    end
end
