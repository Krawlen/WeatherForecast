# frozen_string_literal: true

class ForecastService
  include HTTParty
  include ActiveModel::Validations
  base_uri 'https://api.open-meteo.com/'

  validates :zip_code, :latitude, :longitude, presence: true

  attr_reader :zip_code, :latitude, :longitude

  FORECAST_DAYS = 7
  def initialize(zip_code:, latitude:, longitude:)
    @zip_code = zip_code
    @latitude = latitude
    @longitude = longitude
  end

  def fetch_forecast
    return unless valid?

    raw_forecast = fetch_from_cache
    is_from_cache = raw_forecast.present?
    raw_forecast ||= fetch_from_remote

    return unless raw_forecast

    daily_data = raw_forecast['daily']
    daily_units = raw_forecast['daily_units']
    forecasted_days = (0...ForecastService::FORECAST_DAYS).map do |i|
      DailyForecast.new(time: daily_data['time'][i],
                        weather_code: daily_data['weather_code'][i],
                        max: "#{daily_data['apparent_temperature_max'][i]}#{daily_units['apparent_temperature_max']}",
                        min: "#{daily_data['apparent_temperature_min'][i]}#{daily_units['apparent_temperature_max']}")
    end
    { is_from_cache:, forecasted_days: }
  end

  private

  def cache_key
    "forecast/#{zip_code}"
  end

  def fetch_from_cache
    cached_value = Rails.cache.fetch(cache_key)
    return unless cached_value

    JSON.parse(cached_value).with_indifferent_access
  end

  def fetch_from_remote
    response = self.class.get('/v1/forecast', { query: {
                                latitude:,
                                longitude:,
                                daily: 'apparent_temperature_max,apparent_temperature_min,weather_code',

                                # We want to include the current day in the forecast
                                forecast_days: FORECAST_DAYS
                              } })
    return unless response.success?

    Rails.cache.write(cache_key, response.body, expires_in: 30.minutes)
    JSON.parse(response.body).with_indifferent_access
  end
end
