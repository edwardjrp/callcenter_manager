class Admin::TaxpayerIdentificationsController < ApplicationController
  def index
  end

  def create
    flash[:success] = 'Importacion de numeros fiscales calendarizada.'
    TaxpayerIdentification.upload(params[:dgii])
    redirect_to admin_import_logs_path
  end
end
