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
#  has_sides    :boolean          default(FALSE)
#

class Category < ActiveRecord::Base
  validates :name, :presence=> true, :uniqueness=> true
  before_validation :has_modifiers_when_manage_units
  before_validation :not_multi_when_manage_units
  before_validation :not_sides_when_manage_units
  has_many :products
  attr_accessible :base_product, :has_options, :hidden, :multi, :name, :unit_type
  
  
  
  
  private
    def has_modifiers_when_manage_units
      if has_options == false 
        errors.add(:type_unit, "La categoria no tiene complementos") if type_unit == true
      end
    end
    
    def not_multi_when_manage_units
      if multi == true 
        errors.add(:multi, "Las opciones de esta categoria son unidades") if type_unit == true
        errors.add(:multi, "La categoria no tiene complementos") if has_options == false
      end
    end
    
    
    def not_sides_when_manage_units
      if has_sides == true 
        errors.add(:type_unit, "Las opciones de esta categoria son unidades") if type_unit == true
        errors.add(:has_sides, "La categoria no tiene complementos") if has_options == false
      end
    end
    
end
