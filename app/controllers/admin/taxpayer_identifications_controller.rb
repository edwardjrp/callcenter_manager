#encoding: utf-8
class Admin::TaxpayerIdentificationsController < ApplicationController
  def index
    @tax_ids = TaxpayerIdentification.find_tax_id(params[:q]).order(:idnumber).page(params[:page])
  end

  def create
    
    begin
      TaxpayerIdentification.upload(params[:dgii])
      flash[:success] = 'Importacion de numeros fiscales calendarizada.'    
    rescue Redis::CannotConnectError
      flash[:error] = 'El servico Redis no se esta ejecutando, los tareas de importación no se pueden realizar'
    end
    
    redirect_to admin_import_logs_path
  end
end
