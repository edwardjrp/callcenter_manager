#encoding:  utf-8
class Admin::ReportsController < ApplicationController
    before_filter {|c| c.accessible_by([:admin, :supervisor], root_path)}

    def index
      if !!params[:report].blank? && Report.report_types.include?(params[:report_type])
        @reports = Report.where(name: params[:report_type]).order(:created_at).page(params[:page])
      else
        @reports = Report.order(:created_at).page(params[:page])
      end
    end

    def new
      @report = Report.new
    end

    def create
      @report = Report.new(params[:report])
      start_time = Time.local(params["start_time"]["datetime(1i)"].to_i,
                                params["start_time"]["datetime(2i)"].to_i,
                                params["start_time"]["datetime(3i)"].to_i,
                                params["start_time"]["datetime(4i)"].to_i,
                                params["start_time"]["datetime(5i)"].to_i)
      end_time = Time.local(params["end_time"]["datetime(1i)"].to_i,
                                params["end_time"]["datetime(2i)"].to_i,
                                params["end_time"]["datetime(3i)"].to_i,
                                params["end_time"]["datetime(4i)"].to_i,
                                params["end_time"]["datetime(5i)"].to_i)
      if end_time < start_time
        flash[:error] = 'La horea final es inferior a la hora de inicio'
        render :new
      else
        if @report.generate(start_time, end_time, params[:options])
          flash['success'] = 'Report generado'
          redirect_to admin_reports_path
        else
          flash[:error] = "Un error impidio la generación del reporte"
          render :new
        end
      end
    end

    # def detailed
    #   @reports = Report.detailed.order('created_at DESC').page(params[:page])
    #   @search = Cart.finalized.search(params[:q])
    #   @carts = @search.result(:distinct => true).limit(5)
    # end

    # def generate_detailed 
    #   @search = Cart.finalized.search(params[:q])
    #   @report = Report.new(name: 'Detallado')
    #   begin
    #     @report.process_detailed(@search.result(:distinct => true))
    #     flash['success'] = "Reporte generado"
    #   rescue => error
    #     Rails.logger.error error
    #     flash['error'] = "Un error impidio la generación del reporte"
    #   end
    #   redirect_to admin_reports_detailed_path
    # end

    # def sumary
    #   @reports = Report.sumary.order('created_at DESC').page(params[:page])
    #   start_date = (params[:sumary_report].present? && params[:sumary_report][:start_date].present?) ?  Date.parse(params[:sumary_report][:start_date]) : 1.month.ago.to_date
    #   end_date = (params[:sumary_report].present? && params[:sumary_report][:end_date].present?) ? Date.parse(params[:sumary_report][:end_date]) : Date.current
    #   @carts = Cart.date_range(start_date, end_date).limit(5)
    # end

    # def generate_sumary
    #   start_date =  (params[:sumary_report].present? && params[:sumary_report][:start_date].present?) ? Date.parse(params[:sumary_report][:start_date]) :  1.month.ago.to_date
    #   end_date = (params[:sumary_report].present? && params[:sumary_report][:end_date].present?) ? Date.parse(params[:sumary_report][:end_date]) : Date.current
    #   @report = Report.new(name: 'Consolidado')
    #   begin
    #     @report.process_sumary(Cart.date_range(start_date, end_date), start_date, end_date)
    #     flash['success'] = "Reporte generado"
    #   rescue => error
    #     Rails.logger.error error
    #     flash['error'] = "Un error impidio la generación del reporte"
    #   end
    #   redirect_to admin_report_sumary_path
    # end

    # def coupons
    #   @reports = Report.coupons.order('created_at DESC').page(params[:page])
    #   start_date = (params[:coupons_report].present? && params[:coupons_report][:start_date].present?) ? Date.parse(params[:coupons_report][:start_date]) : 1.month.ago.to_date
    #   end_date = (params[:coupons_report].present? && params[:coupons_report][:end_date].present?) ?  Date.parse(params[:coupons_report][:end_date]) : Date.current
    #   @carts = Cart.date_range(start_date, end_date).limit(5)
    # end

    # def generate_coupons
    #   start_date = (params[:coupons_report].present? && params[:coupons_report][:start_date].present?) ? Date.parse(params[:coupons_report][:start_date]) : 1.month.ago.to_date
    #   end_date = (params[:coupons_report].present? && params[:coupons_report][:end_date].present?) ? Date.parse(params[:coupons_report][:end_date]) : Date.current
    #   @report = Report.new(name: 'Cupones')
    #   begin
    #     flash['success'] = "Reporte generado"
    #     @report.process_coupons(Cart.date_range(start_date, end_date), start_date, end_date)
    #   rescue => error
    #     Rails.logger.error error
    #     flash['error'] = "Un error impidio la generación del reporte"
    #   end
    #   redirect_to admin_report_coupons_path
    # end

    # def discounts
    #   @reports = Report.discounts.order('created_at DESC').page(params[:page])
    #   start_date = (params[:discounts_report].present? && params[:discounts_report][:start_date].present?) ?  Date.parse(params[:discounts_report][:start_date]) : 1.month.ago.to_date
    #   end_date = (params[:discounts_report].present? && params[:discounts_report][:end_date].present?) ? Date.parse(params[:discounts_report][:end_date]) : Date.current
    #   @carts = Cart.discounted.date_range(start_date, end_date).limit(5)
    # end

    # def generate_discounts
    #   start_date = (params[:discounts_report].present? && params[:discounts_report][:start_date].present?) ? Date.parse(params[:discounts_report][:start_date]) : 1.month.ago.to_date
    #   end_date = (params[:discounts_report].present? && params[:discounts_report][:end_date].present?) ? Date.parse(params[:discounts_report][:end_date]) : Date.current
    #   @report = Report.new(name: 'Descuentos')
    #   Rails.logger.debug params
    #   Rails.logger.debug params[:discounts_report].blank?
    #   Rails.logger.debug Date.parse(params[:discounts_report][:start_date])
    #   begin
    #     flash['success'] = "Reporte generado"
    #     @report.process_discounts(Cart.date_range(start_date, end_date), start_date, end_date)
    #   rescue => error
    #     Rails.logger.error error
    #     flash['error'] = "Un error impidio la generación del reporte"
    #   end
    #   redirect_to admin_report_discounts_path
    # end

    # def products_mix
    #   @reports = Report.products_mix.order('created_at DESC').page(params[:page])
    #   start_date = (params[:products_mix_report].present? && params[:products_mix_report][:start_date].present?) ? Date.parse(params[:products_mix_report][:start_date]) : 1.month.ago.to_date
    #   end_date = (params[:products_mix_report].present? && params[:products_mix_report][:end_date].present?) ? Date.parse(params[:products_mix_report][:end_date]) : Date.current
    #   @carts = Cart.completed.date_range(start_date, end_date).limit(5)
    # end

    # def generate_products_mix
    #   start_date = (params[:products_mix_report].present? && params[:products_mix_report][:start_date].present?) ? Date.parse(params[:products_mix_report][:start_date]) : 1.month.ago.to_date
    #   end_date = (params[:products_mix_report].present? && params[:products_mix_report][:end_date].present?) ? Date.parse(params[:products_mix_report][:end_date]) : Date.current
    #   @report = Report.new(name: 'ProductsMix')
    #   begin
    #     flash['success'] = "Reporte generado"
    #     @report.process_products_mix(Cart.date_range(start_date, end_date), start_date, end_date)
    #   rescue => error
    #     Rails.logger.error error
    #     flash['error'] = "Un error impidio la generación del reporte"
    #   end
    #   redirect_to admin_report_products_mix_path
    # end
end
