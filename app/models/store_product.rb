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

class StoreProduct < ActiveRecord::Base
  belongs_to :store
  belongs_to :product
  attr_accessible :depleted_time, :product_id, :available, :store_id


  def self.create_collection(store_id)
    store = Store.find_by_id(store_id)
    return nil unless store.present?
    transaction do 
      Product.all.each do |product|
        StoreProduct.create(store_id: store.id, product_id: product.id, available: true )
      end
    end
    store
  end
end
