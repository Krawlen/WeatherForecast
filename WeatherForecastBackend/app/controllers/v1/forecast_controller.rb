module V1
  class ForecastController < ApplicationController
    def create
      sample_data = { day: 'sun',
                      forecast: {
                        max: '12'
                      } }
      render json: {
        data: [
          sample_data, sample_data, sample_data, sample_data, sample_data, sample_data, sample_data
        ]
      }
    end
  end
end
