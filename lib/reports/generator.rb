# encoding:utf-8
require 'csv'

module Reports
  class Generator
    DISCOUNTS_REPORT = { 
      title: 'Reporte de descuentos',
      columns: [
        'Agente',
        'Nombre del Agente',
        'Autorizado por',
        'Nombre Aut.',
        'Fecha y hora de orden',
        'Tienda',
        'Orden',
        'Info. Cliente',
        'Total Sin descuento',
        'Total Descontado',
        'Total c/ Desc.'
      ],
      single_table: true
    }

    COUPONS_REPORT = { 
      title: 'Reporte de cupones',
      columns: [
        'Código del Cupón',
        'Descripción',
        'Cantidad',
        '% del Total de ordenes',
        '% del Total de los Cupones'
      ],
      single_table: true
    }

    PER_HOUR_REPORT = { 
      title: 'Reporte por hora',
      columns: [
        'Periodo del día',
        'Ordenes',
        'Ventas netas',
        'Tiempo promedio de toma de orden',
        'Ordenes Canceladas',
        'Delivery',
        'Carry Out',
        'Dine In'
      ],
      single_table: true
    }

    DETAILED_REPORT = { 
      title: 'Reporte detallado',
      columns: [
        'No. Orden',
        'Tienda',
        'Nuevo cliente',
        'Cliente',
        'Fecha',
        'Modo de servicio',
        'Agente',
        'Tiempo de toma',
        'Monto de la order',
        'Metodo de pago',
        'Tipo de factura',
        'Estado en pulse',
        'Estado en CC',
        'Ítemes'],
      single_table: true
    }

    PRODUCT_MIX_REPORT = { 
      title: 'Reporte product mix',
      columns: [
        'Categoría',
        'Ítem de Menú',
        'Tamaño',
        'Sabor/Masa',
        'Ventas Netas',
        'Cantidad',
        'Product Mix',
        'Sales Mix',
        'Ordenes',
        'Percentage en Ordenes'
      ],
      single_table: true
    }


    def initialize(relation, report_type, start_datetime, end_datetime, orientation = :landscape, &data_rows)
      @relation = relation
      @report_type = report_type
      @start_datetime_original = start_datetime
      @end_datetime_original = end_datetime
      @start_datetime = @start_datetime_original.strftime('%d %B %Y - %I:%M:%S %p')
      @end_datetime = @end_datetime_original.strftime('%d %B %Y - %I:%M:%S %p')
      @pdf = Prawn::Document.new(top_margin: 70, page_layout: orientation)
      @csv = ''
      @data_rows = data_rows
    end

    def render_pdf
      case @report_type
      when :detailed_report then
        build_detailed_report_pdf
      when :product_mix_report then
        build_product_mix_report_pdf
      when :per_hour_report then
        build_per_hour_report_pdf
      when :coupons_report then
        build_coupons_report_pdf
      when :discounts_report then
        build_discounts_report_pdf
      end
      @pdf.render
    end

    def render_csv
      case @report_type
      when :detailed_report then
        build_detailed_report_csv
      when :product_mix_report then
        build_product_mix_report_csv
      when :per_hour_report then
        build_per_hour_report_csv
      when :coupons_report then
        build_coupons_report_csv
      when :discounts_report then
        build_discounts_report_csv
      end
      @csv
    end

    def self.monetize(amount)
      ActionController::Base.helpers.number_to_currency(amount) || 'N/A'
    end

    def self.percentize(amount)
      ActionController::Base.helpers.number_to_percentage(amount * 100, :delimiter => ',', :separator => '.', :precision => 2)
    end

    private

    def build_discounts_report_csv
      @csv = CSV.generate do |csv|
        csv_title(csv)
        set_pdf_font
        csv_empty_row(csv)
        csv_timestamp(csv)
        csv_empty_row(csv)
        csv << DISCOUNTS_REPORT[:columns]
        @relation.each do |cart|
          csv << @data_rows.call(cart)
        end
        csv_empty_row(csv)
      end
    end

    def build_discounts_report_pdf
      h_1(DISCOUNTS_REPORT[:title])
      set_pdf_font(5)
      space_down
      timestamps
      space_down
      pdf_table = []
      pdf_table << DISCOUNTS_REPORT[:columns]
      @relation.each do |cart|
        pdf_table << @data_rows.call(cart)
      end
      create_table(pdf_table)
    end

    def build_coupons_report_csv
      @csv = CSV.generate do |csv|
        csv_title(csv)
        set_pdf_font
        csv_empty_row(csv)
        csv_timestamp(csv)
        csv_empty_row(csv)
        csv << COUPONS_REPORT[:columns]
        @relation.each do |coupon_code, coupon_count|
          csv << @data_rows.call(coupon_code, coupon_count)
        end
        csv_empty_row(csv)
      end
    end

    def build_coupons_report_pdf
      h_1(COUPONS_REPORT[:title])
      set_pdf_font(7)
      space_down
      timestamps
      space_down
      pdf_table = []
      pdf_table << COUPONS_REPORT[:columns]
      @relation.each do |coupon_code, coupon_count|
        pdf_table << @data_rows.call(coupon_code, coupon_count)
      end
      create_table(pdf_table)
    end

    def build_per_hour_report_csv
      @csv = CSV.generate do |csv|
        csv_title(csv)
        set_pdf_font(5)
        csv_empty_row(csv)
        csv_timestamp(csv)
        csv_empty_row(csv)
        csv << PER_HOUR_REPORT[:columns]
        datetime = @start_datetime_original
        while datetime < @end_datetime_original
          csv << @data_rows.call(datetime)
          datetime += 1.hour
        end
        csv_empty_row(csv)
      end
    end    

    def build_per_hour_report_pdf
      h_1(PER_HOUR_REPORT[:title])
      set_pdf_font(7)
      space_down
      timestamps
      space_down
      pdf_table = []
      pdf_table << PER_HOUR_REPORT[:columns]
      datetime = @start_datetime_original
      while datetime < @end_datetime_original
        pdf_table << @data_rows.call(datetime)
        datetime += 1.hour
      end
      create_table(pdf_table)
    end

    def build_product_mix_report_csv
      @csv = CSV.generate do |csv|
        csv_title(csv)
        set_pdf_font
        csv_empty_row(csv)
        csv_timestamp(csv)
        csv_empty_row(csv)
        csv << PRODUCT_MIX_REPORT[:columns]
        @relation.each do |category, products|
          csv << csv_fill_row([category], PRODUCT_MIX_REPORT[:columns].length, csv)
          products.each do |product, cart_products|
            csv << @data_rows.call(product, cart_products)
          end
        end
        csv_empty_row(csv)
      end
    end

    def build_product_mix_report_pdf
      h_1(PRODUCT_MIX_REPORT[:title])
      set_pdf_font
      space_down
      timestamps
      space_down
      pdf_table = []
      pdf_table << PRODUCT_MIX_REPORT[:columns]
      @relation.each do |category, products|
        pdf_table << fill_row([category], PRODUCT_MIX_REPORT[:columns].length)
        products.each do |product, cart_products|
          pdf_table << @data_rows.call(product, cart_products)
        end
      end
      create_table(pdf_table)
    end

    def build_detailed_report_csv
      @csv = CSV.generate do |csv|
        csv_title(csv)
        set_pdf_font(5)
        csv_empty_row(csv)
        csv_timestamp(csv)
        csv_empty_row(csv)
        csv << DETAILED_REPORT[:columns]
        @relation.each do |cart|
          cart.update_pulse_order_status
          csv << @data_rows.call(cart)
        end
        csv_empty_row(csv)
      end
    end

    def csv_title(csv)
      case @report_type
      when :detailed_report then
        csv_fill_row([DETAILED_REPORT[:title]], DETAILED_REPORT[:columns].length, csv )
      when :product_mix_report then
        csv_fill_row([PRODUCT_MIX_REPORT[:title]], PRODUCT_MIX_REPORT[:columns].length, csv )
      when :per_hour_report then
        csv_fill_row([PER_HOUR_REPORT[:title]], PER_HOUR_REPORT[:columns].length, csv )
      when :coupons_report then
        csv_fill_row([COUPONS_REPORT[:title]], COUPONS_REPORT[:columns].length, csv )
      when :discounts_report then
        csv_fill_row([DISCOUNTS_REPORT[:title]], DISCOUNTS_REPORT[:columns].length, csv )
      end
    end

    def csv_timestamp(csv)
      row_length = 1
      case @report_type
      when :detailed_report then
        row_length = DETAILED_REPORT[:columns].length
      when :product_mix_report then
        row_length = PRODUCT_MIX_REPORT[:columns].length
      when :per_hour_report then
        row_length = PER_HOUR_REPORT[:columns].length
      when :coupons_report then
        row_length = COUPONS_REPORT[:columns].length
      when :discounts_report then
        row_length = DISCOUNTS_REPORT[:columns].length
      end
      csv_fill_row([@start_datetime], row_length, csv )
      csv_fill_row([@end_datetime], row_length, csv )
    end

    def csv_fill_row(start_array, size, csv)
      temp_array = start_array
      start_array.length.upto(size) { temp_array << nil }
      csv << temp_array
    end

    def fill_row(start_array, size)
      temp_array = start_array
      start_array.length.upto(size) { temp_array << nil }
      temp_array
    end

    def csv_empty_row(csv)
      case @report_type
      when :detailed_report then
        csv_fill_row([nil], DETAILED_REPORT[:columns].length, csv)
      end
    end

    def build_detailed_report_pdf
      h_1(DETAILED_REPORT[:title])
      set_pdf_font(5)
      space_down
      timestamps
      space_down
      pdf_table = []
      pdf_table << DETAILED_REPORT[:columns]
      @relation.each do |cart|
        cart.update_pulse_order_status
        pdf_table << @data_rows.call(cart)
      end
      create_table(pdf_table)
    end

    def create_table(pdf_array)
      @pdf.table pdf_array do
        row(0).font_style = :bold
        style(row(0), :background_color => '4682B4')
        cells.borders = []
        self.row_colors = ["F8F8FF", "ADD8E6"]
        self.header = true
      end
    end

    def space_down
      @pdf.move_down 20
    end

    def timestamps
      @pdf.text "Inicio #{@start_datetime}", size: 10, style: :bold
      @pdf.text "Conclusión #{@end_datetime}", size: 10, style: :bold
    end

    def set_pdf_font(font_size = 7)
      @pdf.font "Helvetica", size: font_size
    end

    def h_1(text)
      @pdf.text text, size: 20, style: :bold
    end

    def h_2(text)
      @pdf.text text, size: 15, style: :bold
    end

    def h_3(text)
      @pdf.text text, size: 10, style: :bold
    end

  end
end
