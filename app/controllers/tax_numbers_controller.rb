class TaxNumbersController < ApplicationController
  def create
    @client = Client.find(params[:client_id])
    @tax_number = @client.tax_numbers.new(params[:tax_number])
    respond_to do |format|
      if @tax_number.save
        format.json { render json: @tax_number }
      else
        format.json { render json: @tax_number.errors.full_messages.to_sentence, status: 422 }
      end
    end
    
  end
end
