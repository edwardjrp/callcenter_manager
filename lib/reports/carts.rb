module Reports

  module Carts

    extend ActiveSupport::Concern

    module ClassMethods
      # detailed reports
      def csv_detailed_report
        CSV.generate do |csv|
          csv << ['No. Orden', 'Tienda', 'Nuevo cliente', 'Cliente', 'Fecha', 'Modo de servicio', 'Agente', 'Tiempo de toma', 'Monto de la order', 'Pago efectivo', 'Tipo de factura', 'Estado en pulse']
          all.each do |cart|
            csv << [
              cart.id,
              cart.store.storeid,
              (cart.client && cart.client.carts.count == 1) ? '*' : '',
              "#{cart.client.first_name} #{cart.client.last_name} - #{cart.client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')}",
              cart.complete_on.strftime('%Y-%m-%d %H:%M:%S'), # there has to be a completed_on field
              cart.service_method,
              cart.user.idnumber,
              cart.take_time,
              cart.payment_amount,
              cart.payment_type,
              cart.fiscal_type,
              cart.order_progress,
              cart.products.map(&:productname).to_sentence
               ]
          end
        end
      end
      # end self.csv_detailed_report

      def to_csv(options = {})
        CSV.generate(options) do |csv|
          csv << column_names
          all.each do |cart|
            csv << cart.attributes.values_at(*column_names)
          end
        end
      end
      # end self.csv_detailed_report
    end
    # end module ClassMethods
  end

end