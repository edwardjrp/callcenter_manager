# encoding: utf-8
require 'csv'

module Reports

  module Carts

    extend ActiveSupport::Concern

    module ClassMethods


      def pdf_coupons_report(start_date, end_date)
        pdf = Prawn::Document.new(top_margin: 70)
        pdf.font "Helvetica", :size => 10
        pdf.text "Reporte Consolidado", size: 20, style: :bold
        pdf.move_down 20
        pdf.text "Inicio #{start_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.text "Conclusión #{end_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.move_down 20

        coupons_table = []
        coupons_table << ['Código',  'Descripción', 'Cantidad', '% de ordenes', '% de cupones']
        completed.joins(:coupons).group('coupons.code').count.each do |coupon_code, coupon_count|
          coupon = Coupon.find_by_code(coupon_code)
          coupons_table << [coupon_code,  coupon, coupon_count, coupon_count / completed.count , coupon_count / completed.joins(:coupons).count] if coupon
        end

        pdf.table coupons_table do
          row(0).font_style = :bold
          style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = true
        end

        pdf
      end


      def pdf_sumary_report(start_date, end_date)
        
        pdf = Prawn::Document.new(top_margin: 70)
        pdf.font "Helvetica", :size => 10
        pdf.text "Reporte Consolidado", size: 20, style: :bold
        pdf.move_down 20
        pdf.text "Inicio #{start_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.text "Conclusión #{end_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.move_down 20
        pdf.text "Ventas", size: 17, style: :bold
        pdf.move_down 20

        sale_table = []
        sale_table << [   'Ventas Brutas', ActionController::Base.helpers.number_to_currency(self.completed.sum('payment_amount'))  ]
        sale_table << [   'Ventas Netas', ActionController::Base.helpers.number_to_currency(self.completed.sum('net_amount'))  ]
        sale_table << [   'Canceladas', self.abandoned.count  ]

        pdf.table sale_table do
          row(0).font_style = :bold
          # style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = false
        end

        pdf.move_down 20
        pdf.text "Ordenes antes y despues de las 4:00 pm", size: 17, style: :bold
        pdf.move_down 20

        lunch = completed.where("date_part('hour',complete_on) < 16")
        dinner = completed.where("date_part('hour',complete_on) > 16")

        time_table = []
        time_table << [   'Almuerzo', lunch.count , ActionController::Base.helpers.number_to_currency(lunch.sum('payment_amount'))  ]
        time_table << [   'Cena', dinner.count, ActionController::Base.helpers.number_to_currency(dinner.sum('net_amount'))  ]
    

        pdf.table time_table do
          row(0).font_style = :bold
          # style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = false
        end

        pdf.move_down 20


        pdf.text "Ordenes", size: 15, style: :bold

        service_table = []
        completed.group(:service_method).count.each do | service_method, service_count |
          service_table << [ service_method, ActionController::Base.helpers.number_to_percentage((service_count.to_d / self.completed.count.to_d) * 100,:delimiter => ',', :separator => '.', :precision => 2),  ActionController::Base.helpers.number_to_currency(self.completed.group(:service_method).sum('payment_amount')[service_method])]
        end
        pdf.move_down 20

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

        pdf.move_down 20
        pdf.text "Otros indicadores", size: 15, style: :bold
        pdf.move_down 20

        username = 'cdruser'
        password = 'cdrus3rd1s8x10bctb3st'
        nonce  = SecureRandom.hex(10)
        token = Digest::MD5.hexdigest("#{username}:#{nonce}:#{Digest::MD5.hexdigest(password)}")
        url = URI.parse("http://192.168.85.80:8080/totalincoming.json?fecha1=#{start_date}&fecha2=#{end_date}&token=#{token}&nonce=#{nonce}")
        request = Net::HTTP.get(url)
        total_call = JSON.parse(request)["result"]["totalincoming"]
        # {"resultcode"=>0, "result"=>{"totalincoming"=>16573}}
        user_with_completed_in_range = User.joins(:carts).where('carts.completed = true').where('carts.created_at > ? and carts.created_at < ?', start_date, end_date)

        other_table = []
        other_table << [ 'Orden promedio', ActionController::Base.helpers.number_to_currency(completed.average('payment_amount')) ]
        avg_cart_per_user = user_with_completed_in_range.average('carts_count')
        other_table << [ 'Ventas por agente promedio', avg_cart_per_user ]
        other_table << [ 'Tiempo de orde promedio', (completed.sum(&:take_time) / completed.count) ]
        other_table << [ 'Llamadas entrantes', total_call ]
        other_table << [ 'Llamadas por agente', (total_call / user_with_completed_in_range.count) ]

        pdf.table other_table do
          row(0).font_style = :bold
          # style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = false
        end

        pdf.move_down 20
        pdf.text "products mix", size: 15, style: :bold
        pdf.move_down 20
        products_table = []

        joins(:products).group('products.productname').count.each do | product, product_count |
          products_table << [ product, product_count  ]
        end

        pdf.table products_table do
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