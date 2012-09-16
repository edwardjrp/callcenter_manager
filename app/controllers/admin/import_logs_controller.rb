class Admin::ImportLogsController < ApplicationController
  def index
    @import_logs = ImportLog.order('created_at DESC').page(params[:page])
    respond_to do |format|
      format.json{ render json: @import_logs}
      format.html
    end
  end

  def show
    @import_log = ImportLog.find(params[:id])
    @import_events = @import_log.import_events.order('created_at DESC').page(params[:page])
  end

  def create
    enqueue_task(params[:log_type])
    redirect_to :back
  end

  private
    def enqueue_task(log_type)
      case log_type
      when ImportLog.products_import
        flash[:success] = 'Importacion de productos calendarizada.'
        ProductsImport.perform_async
      when ImportLog.coupons_import
        flash[:success] = 'Importacion de cupones calendarizada.'
        CouponsImport.perform_async
      else
        flash[:alert] = 'La tarea solicitada no ha sido reconocida por el sistema'
      end

    end

end
