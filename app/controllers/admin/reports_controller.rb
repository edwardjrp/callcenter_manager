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
        # flash[:info] = params
        ReportsWorker.perform_async(params[:report][:name], start_time, end_time, params[:options])
        flash['success'] = 'Generación del reporte calendarizada'
        redirect_to admin_reports_path
      end
    end
end
