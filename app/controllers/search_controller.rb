class SearchController < ApplicationController
  def index
    render json: AltFuelService.find_by_zipcode(params[:q])
  end
end
