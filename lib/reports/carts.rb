# encoding: utf-8
require 'csv'

module Reports

  module Carts

    extend ActiveSupport::Concern

    module ClassMethods


      def pdf_products_mix_report(start_date, end_date)
        pdf = Prawn::Document.new(top_margin: 70, :page_layout => :landscape)
        pdf.font "Helvetica", :size => 7
        pdf.text "Reporte Consolidado", size: 20, style: :bold
        pdf.move_down 20
        pdf.text "Inicio #{start_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.text "Conclusión #{end_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.move_down 20

        products_mix_table = []
        products_mix_table << [
          'Categoría',
          'Ítem de Menú',
          'Tamaño',
          'Sabor/Masa',
          'Ventas Netas',
          'Cantidad',
          'Product Mix',
          'Sales Mix',
          'Ordenes',
          'Percent of Orders'
        ]

        mix = CartProduct.products_mix(start_date, end_date)

        mix.each do |category, products|
          products_mix_table << [
            category,
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            ''
          ]
          products.each do |product, cart_products|
            products_mix_table << [
              '',
              product[:product].productname,
              product[:product].sizecode,
              product[:product].flavorcode,
              monetize(product[:cart_products][:total_sales]),
              product[:cart_products][:total_count],
              percentize(product[:cart_products][:total_sales].to_d / completed.date_range(start_date, end_date).sum('payment_amount')),
              percentize(product[:cart_products][:total_count].to_d / CartProduct.total_items_sold(start_date, end_date)),
              product[:total_carts],
              percentize( product[:total_carts].to_d / completed.date_range(start_date, end_date).count.to_d)
            ]
          end
        end

        pdf.table products_mix_table do
          row(0).font_style = :bold
          style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = true
        end

        pdf

      end

      def pdf_discounts_report(start_date, end_date)
        pdf = Prawn::Document.new(top_margin: 70, :page_layout => :landscape)
        pdf.font "Helvetica", :size => 6
        pdf.text "Reporte Consolidado", size: 20, style: :bold
        pdf.move_down 20
        pdf.text "Inicio #{start_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.text "Conclusión #{end_date.strftime('%d %B %Y')}", size: 10, style: :bold
        pdf.move_down 20

        discounts_table = []
        discounts_table << [
          'Agente',
          'Nombre del Agente',
          'Autorizado por',
          'Nombre del autorizador',
          'Fecha y hora de la orden',
          'Tienda',
          'Orden',
          'Info Cliente',
          'Total sin descuento',
          'Total descontado',
          'Total con descuento'
        ]
        discounted.each do |cart|
          discounts_table << [
            cart.agent_info,
            cart.agent_info_name,
            cart.discount_authorizer,
            cart.discount_authorizer_name,
            cart.completion_info,
            cart.store_info_id,
            cart.complete_id,
            cart.client_info,
            monetize(cart.payment_amount),
            monetize(cart.discount),
            monetize((cart.payment_amount - cart.discount).to_d)
          ]
        end

        pdf.table discounts_table do
          row(0).font_style = :bold
          style(row(0), :background_color => '4682B4')
          cells.borders = []
          # columns(1..3).align = :right
          self.row_colors = ["F8F8FF", "ADD8E6"]
          self.header = true
        end

        pdf
      end

      def monetize(amount)
        ActionController::Base.helpers.number_to_currency(amount)
      end

      def percentize(amount)
        ActionController::Base.helpers.number_to_percentage(amount * 100,:delimiter => ',', :separator => '.', :precision => 2)
      end

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
        sale_table << [   'Ventas Brutas', monetize(self.completed.sum('payment_amount'))  ]
        sale_table << [   'Ventas Netas', monetize(self.completed.sum('net_amount'))  ]
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
        time_table << [   'Almuerzo', lunch.count , monetize(lunch.sum('payment_amount'))  ]
        time_table << [   'Cena', dinner.count, monetize(dinner.sum('net_amount'))  ]
    

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
          service_table << [ service_method, percentize(service_count.to_d / self.completed.count.to_d),  monetize(self.completed.group(:service_method).sum('payment_amount')[service_method])]
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

        other_table = []
        other_table << [ 'Orden promedio', monetize(completed.average('payment_amount')) ]
        avg_cart_per_user = User.carts_completed_in_range(start_date, end_date).average('carts_count')
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
              monetize(cart.payment_amount),
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
            monetize(cart.payment_amount),
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
          csv << ['Completada en', 'Numero de orden', 'Forma de pago', 'Modo de servicio', 'Tipo fiscal']
          all.each do |cart|
            csv << [
              cart.completion_info,
              cart.store_order_id_info,
              cart.payment_type,
              cart.service_method,
              cart.fiscal_type
            ]
          end
        end
      end
      # end self.csv_detailed_report
    end
    # end module ClassMethods
  end

end