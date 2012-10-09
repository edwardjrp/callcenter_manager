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

  def update
    @tax_number = TaxNumber.find(params[:id])
    respond_to do |format|
      if @tax_number.update_attributes(params[:tax_number])
        format.json { render json: @tax_number }
      else
        format.json { render json: @tax_number.errors.full_messages.to_sentence, status: 422 }
      end
    end
  end

  def verify
    @tax_number = TaxNumber.find(params[:id])
    @tax_number.verify
    respond_to do |format|
      format.js { render text: @tax_number.verified }
    end
  end


  def destroy
    @tax_number = TaxNumber.find(params[:id])
    @tax_number.destroy
    respond_to do | format |
      format.js{ render nothing: true, status: 200 }
    end
  end
end
