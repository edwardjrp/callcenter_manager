class ProductsImport
  # require "csv"
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    store_id = ( Kapiqua.price_store_id || Kapiqua.defaults[:price_store_id] )
    soap_client = SoapClient.new(( Kapiqua.price_store_ip || Kapiqua.defaults[:price_store_ip] ),(Kapiqua.pulse_port || Kapiqua.defaults[:pulse_port]), ( Kapiqua.document_location || Kapiqua.defaults[:document_location]))
    load_product_to_db(soap_client.get({"StoreID"=>store_id}, 'get_store_products'))
  end

  private 
    def load_product_to_db(xml_string)
      doc= Nokogiri::XML(xml_string)
      products_table = doc.css('Products').first.inner_text.gsub(/"/,'&quot;')
      CSV.parse(products_table, {:col_sep=>"\t", :headers=>true}) do |row|
        # validate descontinued
        Product.create do |product|
          product.category_id = Category.find_or_create_by_name(row['CategoryCode']).id
          product.productcode = row['ProductCode']
          product.productname = row['ProductName']
          product.options = row['Options']
          product.sizecode = row['SizeCode']
          product.flavorcode = row['FlavorCode']
          product.optionselectiongrouptype = row['OptionSelectionGroupType']
          product.productoptionselectiongroup = row['ProductOptionSelectionGroup']
        end
      end
    end
end
