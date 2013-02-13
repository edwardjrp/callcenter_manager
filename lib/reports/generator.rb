# encoding:utf-8
require 'csv'

module Reports
  class Generator
    DETAILED_REPORT = { 
      title: 'Reporte detallado',
      columns: [
        'No. Orden',
        'Tienda',
        'Nuevo cliente',
        'Cliente', 'Fecha',
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


    def initialize(relation, report_type, start_date, end_date, oriantion = :landscape)
      @relation = relation
      @report_type = report_type
      @start_date = start_date
      @end_date = end_date
      @pdf = Prawn::Document.new(top_margin: 70, page_layout: oriantion)
      @csv = ''
    end

    def render
      case @report_type
      when :detailed_report then
        h_1(DETAILED_REPORT[:title])
        set_pdf_font(5)
        space_down
        timestamps
        space_down
        pdf_table = []
        pdf_table << DETAILED_REPORT[:columns]
        @relation.each do |cart|
          pdf_table << yield(cart)
        end
        create_table(pdf_table)
      end
      @pdf.render
    end

    def self.monetize(amount)
      ActionController::Base.helpers.number_to_currency(amount)
    end

    private

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
      @pdf.text "Inicio #{@start_date.strftime('%d %B %Y')}", size: 10, style: :bold
      @pdf.text "Conclusión #{@end_date.strftime('%d %B %Y')}", size: 10, style: :bold
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
