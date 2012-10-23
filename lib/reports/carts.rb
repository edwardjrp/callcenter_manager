# encoding: utf-8
require 'csv'

module Reports

  module Carts

    extend ActiveSupport::Concern

    module InstanceMethods
      def store_info
        return 'N/A' if store.nil?
        store.name
      end

      def new_client?
        return 'N/A' if client.nil?
        client.carts.count == 1 ? '*' : ''
      end

      def client_info
        return 'N/A' if client.nil?
        return "#{client.full_name} - #{client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')}" if client.phones.count.nonzero?
        client.full_name
      end

      def completion_info
        return 'N/A' if complete_on.nil?
        complete_on.strftime('%Y-%m-%d %H:%M:%S')
      end

      def agent_info
        return 'N/A' if user.nil?
        user.idnumber.gsub(/([0-9]{3})([0-9]{7})([0-9]{1})/,'\\1-\\2-\\3')
      end

      def take_time_info
        return 'N/A' if complete_on.nil?
        return 'N/A' if started_on.nil?
        take_time
      end




    end

    module ClassMethods


      def pdf_sumary_report(start_date, end_date)
        
        pdf = Prawn::Document.new(top_margin: 70)
        pdf.font "Helvetica", :size => 10
        pdf.text "Reporte Consolidado", size: 20, style: :bold
        pdf.move_down 20
        pdf.text "Inicio #{start_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.text "Conclusión #{end_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.move_down 20
        pdf.text "Ventas", size: 17, style: :bold


        sale_table = []
        sale_table << [   'Ventas Brutas', ActionController::Base.helpers.number_to_currency(self.completed.sum('payment_amount'))  ]
        sale_table << [   'Ventas Netas', ActionController::Base.helpers.number_to_currency(self.completed.sum('net_amount'))  ]
        sale_table << [   'Canceladas', self.abandoned.count  ]

        pdf.move_down 20

        pdf.text "Ordenes", size: 15, style: :bold

        service_table = []
        completed.group(:service_method).count.each do | service_method, service_count |
          service_table << [ service_method, ActionController::Base.helpers.number_to_percentage((service_count.to_d / self.completed.count.to_d) * 100,:delimiter => ',', :separator => '.', :precision => 2),  ActionController::Base.helpers.number_to_currency(self.completed.group(:service_method).sum('payment_amount')[service_method])]
        end
        pdf.move_down 20

        pdf.table sale_table do
          row(0).font_style = :bold
          # style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = false
        end

        pdf.move_down 20
        pdf.text "Modos de servicio", size: 15, style: :bold
        pdf.move_down 20
        pdf.table service_table do
          row(0).font_style = :bold
          # style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = false
        end
        pdf
      end


      # detailed reports
      def csv_detailed_report
        CSV.generate do |csv|
          csv << ['No. Orden', 'Tienda', 'Nuevo cliente', 'Cliente', 'Fecha', 'Modo de servicio', 'Agente', 'Tiempo de toma', 'Monto de la order', 'Pago efectivo', 'Tipo de factura', 'Estado en pulse', 'products']
          all.each do |cart|
            csv << [
              cart.id,
              cart.store_info,
              cart.new_client?,
              cart.client_info,
              cart.completion_info, # there has to be a completed_on field
              cart.service_method,
              cart.agent_info,
              cart.take_time_info,
              ActionController::Base.helpers.number_to_currency(cart.payment_amount),
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
            cart.store_info,
            cart.new_client?,
            cart.client_info,
            cart.completion_info, # there has to be a completed_on field
            cart.service_method,
            cart.agent_info,
            cart.take_time_info,
            ActionController::Base.helpers.number_to_currency(cart.payment_amount),
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