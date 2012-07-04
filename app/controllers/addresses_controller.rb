
class AddressesController < ApplicationController
  def areas
    @areas = Area.find_area(params)
    respond_to do |format|
      format.json{ render json: @areas}
    end
  end
end
