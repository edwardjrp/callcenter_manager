# == Schema Information
#
# Table name: store_products
#
#  id            :integer          not null, primary key
#  store_id      :integer
#  product_id    :integer
#  available     :boolean          default(FALSE)
#  depleted_time :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe StoreProduct do
  describe "Validations" do
    it{should belong_to :product}
    it{should belong_to :store}
  end
end
