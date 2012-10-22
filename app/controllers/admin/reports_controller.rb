#encoding:  utf-8
class Admin::ReportsController < ApplicationController
    before_filter {|c| c.accessible_by([:admin], root_path)}

    def detailed
      @reports = Report.detailed.order('created_at DESC').page(params[:page])
      @search = Cart.finalized.search(params[:q])
      @carts = @search.result(:distinct => true).limit(5)
    end

    def generate_detailed 
      @search = Cart.finalized.search(params[:q])
      @report = Report.create(name: 'Detallado')
      begin
        @report.process(@search.result(:distinct => true))
        flash['success'] = "Reporte generado"
      rescue => error
        Rails.logger.info error
        flash['error'] = "Un error impidio la generación del reporte"
      end
      redirect_to admin_reports_detailed_path
    end
end
