module V1
  class ForecastController < ApplicationController
    def create
      service = ForecastService.new(zip_code: params[:zip_code], latitude: params[:latitude],
                                    longitude: params[:longitude])

      return render json: { errors: service.errors.messages }, status: :unprocessable_entity unless service.valid?

      daily_forecasts = service.fetch_forecast

      return render json: { errors: 'Upstream service is unavailable. Try again later' } unless daily_forecasts

      render json: {
        data: {
          forecasted_days: daily_forecasts[:forecasted_days],
          is_from_cache: daily_forecasts[:is_from_cache]
        }
      }
    end
  end
end
