namespace :products do

  desc "Import the list of accounts"
  task :remove_duplicate => :environment do
    Category.all.each do |category|
      category.products.map(&:productcode).uniq.each do |product_code|
        products = category.products.where(productcode: product_code)
        if products.count > 1
          staying_product = products.first
          products_to_delete = products.all - [staying_product]
          products_to_delete.each { |product| product.destroy }
        end
      end
    end
  end

end