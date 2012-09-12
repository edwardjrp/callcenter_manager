# encoding: utf-8
class CouponsImport
  
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    import_log = ImportLog.create(log_type: ImportLog.coupons_import, state: 'Iniciando')
    store_id = ( Kapiqua.price_store_id || Kapiqua.defaults[:price_store_id] )
    soap_client = SoapClient.new(( Kapiqua.price_store_ip || Kapiqua.defaults[:price_store_ip] ),(Kapiqua.pulse_port || Kapiqua.defaults[:pulse_port]), ( Kapiqua.document_location || Kapiqua.defaults[:document_location]))
    begin
      load_coupon_to_db(soap_client.get({"StoreID"=>store_id}, 'get_store_coupons'), import_log)  
    rescue Exception => e
      import_log.import_events.create(name: 'Error al importar cupones desde pulse', subject: 'get_store_coupons', message: e.message)
      import_log.update_attributes(state: 'Falló')
    end
    
  end

  private 
    def load_coupon_to_db(xml_string, import_log)
      coupons_xml= Nokogiri::XML(xml_string)
      coupons_xml.css("Coupon").each do |coupon_xml|
        coupon_found = Coupon.find_by_code(coupon_xml.css("Code").inner_text)
        unless coupon_found.present? && coupon_found.discontinued = false
          Coupon.create do |coupon| 
            coupon.code = coupon_xml.css("Code").inner_text
            coupon.description = coupon_xml.css("Description").inner_text
            coupon.generated_description = coupon_xml.css("GeneratedDescription").inner_text
            coupon.minimum_price = coupon_xml.css("MinimumPrice").inner_text
            # coupon.discount_value = coupon_xml.css("DiscountValue").inner_text
            coupon.hidden = coupon_xml.css("Hidden").inner_text
            coupon.secure = coupon_xml.css("Secure").inner_text
            coupon.effective_days = coupon_xml.css("EffectiveDays").inner_text
            coupon.order_sources = coupon_xml.css("OrderSources").css("OrderSource").map(&:inner_text).join('|')
            coupon.service_methods = coupon_xml.css("ServiceMethods").css("ServiceMethod").map(&:inner_text).join('|')
            coupon.expiration_date = coupon_xml.css("ExpirationDate").inner_text
            coupon.effective_date = coupon_xml.css("AffectiveDate").inner_text
          end
          import_log.import_events.create(name: 'Nuevo cupón agregado', subject: coupon_xml.css("Code").inner_text , message: "Se agrego #{coupon_xml.css("Description").inner_text}")
        else
          import_log.import_events.create(name: 'Conflicto de Importación', subject:"#{coupon_found.id} - #{coupon_found.code}" , message: 'Durante la importación se encontro un cupón identico,  que no esta descontinuado')
        end
        
      end
      import_log.update_attributes(state: 'Completado')
    end

  
end
