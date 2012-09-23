#encoding: utf-8
class Admin::ImportLogsController < ApplicationController
  def index
    @import_logs = ImportLog.order('created_at DESC').page(params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @import_log = ImportLog.find(params[:id])
    @import_events = @import_log.import_events.order('created_at DESC').page(params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    enqueue_task(params[:log_type])
    redirect_to :back
  end

  private
    def enqueue_task(log_type)
      begin
        case log_type
        when ImportLog.products_import
          ProductsImport.perform_async
          flash[:success] = 'Importacion de productos calendarizada.'
        when ImportLog.coupons_import
          CouponsImport.perform_async
          flash[:success] = 'Importacion de cupones calendarizada.'
        else
          flash[:alert] = 'La tarea solicitada no ha sido reconocida por el sistema'
        end
      rescue Redis::CannotConnectError
        flash[:error] = 'El servico Redis no se esta ejecutando, los tareas de importación no se pueden realizar'
      end

    end

end
