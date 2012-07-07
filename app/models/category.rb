# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  has_options     :boolean          default(FALSE)
#  type_unit       :boolean          default(FALSE)
#  multi           :boolean          default(FALSE)
#  hidden          :boolean          default(FALSE)
#  base_product    :integer
#  flavor_code_src :string(255)
#  flavor_code_dst :string(255)
#  size_code_src   :string(255)
#  size_code_dst   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Category < ActiveRecord::Base
  attr_accessible :base_product, :flavor_code_dst, :flavor_code_src, :has_options, :hidden, :multi, :name, :size_code_dst, :size_code_src, :unit_type
end
