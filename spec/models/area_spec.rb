# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city_id    :integer
#  store_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Area do
  pending "add some examples to (or delete) #{__FILE__}"
end
