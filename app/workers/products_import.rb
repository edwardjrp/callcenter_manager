# encoding: utf-8
class ProductsImport
  require "csv"
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    import_log = ImportLog.create(log_type: ImportLog.products_import, state: 'Iniciando')
    store_id = ( Kapiqua.price_store_id || Kapiqua.defaults[:price_store_id] )
    soap_client = SoapClient.new(( Kapiqua.price_store_ip || Kapiqua.defaults[:price_store_ip] ),(Kapiqua.pulse_port || Kapiqua.defaults[:pulse_port]), ( Kapiqua.document_location || Kapiqua.defaults[:document_location]))
    begin
      load_product_to_db(soap_client.get({"StoreID"=>store_id}, 'get_store_products'), import_log)  
    rescue Exception => e
      import_log.import_events.create(name: 'Error al importar productos desde pulse', subject: 'get_store_products', message: e.message)
      import_log.update_attributes(state: 'Falló')
    end
    
  end

  private 
    def load_product_to_db(xml_string, import_log)
      doc= Nokogiri::XML(xml_string)
      products_table = doc.css('Products').first.inner_text.gsub(/"/,'&quot;')
      CSV.parse(products_table, {:col_sep=>"\t", :headers=>true}) do |row|
        # find product and check if descontinued
        product_to_find = product_present?( row['CategoryCode'], row['ProductCode'], row['ProductName'], row['Options'], row['SizeCode'], row['FlavorCode'], row['OptionSelectionGroupType'], row['ProductOptionSelectionGroup'])
        unless product_to_find.present? && product_to_find.discontinued == false
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
          import_log.import_events.create(name: 'Nuevo producto agregado', subject: row['ProductCode'] , message: "Se agrego #{row['ProductName']}")
        else
          import_log.import_events.create(name: 'Conflicto de Importación', subject:"#{product_to_find.id} - #{product_to_find.productcode}" , message: 'Durante la importación se encontro un product identico, que no esta descontinuado')
        end
        # end find product and check if discontinued
      end
      import_log.update_attributes(state: 'Completado')
    end

    def product_present?(categorycode, productcode, producname, options, sizecode, flavorcode, optionselectiongrouptype, productoptionselectiongroup)
      found = Product.where(productcode: productcode, productname: producname, options: options,
       sizecode: sizecode, flavorcode: flavorcode, optionselectiongrouptype: optionselectiongrouptype,
       productoptionselectiongroup: productoptionselectiongroup).first
      return found if (found && found.category && found.category.name == categorycode)
    end
end
