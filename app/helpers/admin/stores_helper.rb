module Admin::StoresHelper
  
  def store_product(store, product)
    StoreProduct.where(:store_id=> store.id, :product_id=>product.id).first
  end
end
