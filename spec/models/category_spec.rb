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

require 'spec_helper'

describe Category do
  pending "add some examples to (or delete) #{__FILE__}"
end
