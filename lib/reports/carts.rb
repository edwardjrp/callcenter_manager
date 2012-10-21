require 'csv'

module Reports

  module Carts

    extend ActiveSupport::Concern

    module ClassMethods
      # detailed reports
      def csv_detailed_report
        CSV.generate do |csv|
          csv << ['No. Orden', 'Tienda', 'Nuevo cliente', 'Cliente', 'Fecha', 'Modo de servicio', 'Agente', 'Tiempo de toma', 'Monto de la order', 'Pago efectivo', 'Tipo de factura', 'Estado en pulse', 'products']
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


      def pdf_detailed_report
        pdf = Prawn::Document.new(top_margin: 70, :page_layout => :landscape)
        pdf.font "Helvetica", :size => 5
        pdf.text "Reporte detallado", size: 20, style: :bold
        pdf.move_down 20
        pdf_table = []
        pdf_table << ['No. Orden', 'Tienda', 'Nuevo cliente', 'Cliente', 'Fecha', 'Modo de servicio', 'Agente', 'Tiempo de toma', 'Monto de la order', 'Pago efectivo', 'Tipo de factura', 'Estado en pulse', 'products']
        all.each do |cart|
          pdf_table << [
            cart.id,
            "cart.store.storeid",
            (cart.client && cart.client.carts.count == 1) ? '*' : '',
            "#{cart.client.first_name} #{cart.client.last_name} - #{cart.client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')}",
            "cart.complete_on.strftime('%Y-%m-%d %H:%M:%S')", # there has to be a completed_on field
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
        pdf.table pdf_table do
          row(0).font_style = :bold
          style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = true
        end
        pdf
      end


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