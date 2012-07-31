module Admin::StoresHelper
  
  def store_product(store, product)
    StoreProduct.where(:store_id=> store.id, :product_id=>product.id).first
  end
  
  def store_product_class(store, product)
    store_product = StoreProduct.where(:store_id=> store.id, :product_id=>product.id).first
    if store_product
      if store_product.available == true
        return 'btn-primary'
      else
        return 'btn-inverse'
      end
    end
  end
end
