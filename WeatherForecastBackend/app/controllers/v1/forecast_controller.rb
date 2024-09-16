module V1
  class ForecastController < ApplicationController
    def create
      service = ForecastService.new(zip_code: params[:zip_code], latitude: params[:latitude],
                                    longitude: params[:longitude])
      daily_forecasts = service.fetch_forecast

      render json: {
        data: daily_forecasts
      }
    end
  end
end
