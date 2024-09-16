module V1
  class ForecastController < ApplicationController
    def create
      service = ForecastService.new(zip_code: params[:zip_code], latitude: params[:latitude],
                                    longitude: params[:longitude])
      daily_forecasts = service.fetch_forecast

      render json: {
        data: {
          forecasted_days: daily_forecasts[:forecasted_days],
          is_from_cache: daily_forecasts[:is_from_cache]
        }
      }
    end
  end
end
