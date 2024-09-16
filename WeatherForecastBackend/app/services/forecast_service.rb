# frozen_string_literal: true

class ForecastService
  include HTTParty
  base_uri 'https://api.open-meteo.com/'

  attr_reader :zip_code, :latitude, :longitude

  FORECAST_DAYS = 7
  def initialize(zip_code:, latitude:, longitude:)
    @zip_code = zip_code
    @latitude = latitude
    @longitude = longitude
  end

  def fetch_forecast
    response = self.class.get('/v1/forecast', { query: {
                                latitude:,
                                longitude:,
                                daily: 'apparent_temperature_max,apparent_temperature_min,weather_code',

                                # We want to include the current day in the forecast
                                forecast_days: FORECAST_DAYS

                              } })
    raw_forecast = JSON.parse(response.body).with_indifferent_access
    puts raw_forecast
    daily_data = raw_forecast['daily']
    daily_units = raw_forecast['daily_units']

    (0...ForecastService::FORECAST_DAYS).map do |i|
      DailyForecast.new(time: daily_data['time'][i],
                        weather_code: daily_data['weather_code'][i],
                        max: "#{daily_data['apparent_temperature_max'][i]}#{daily_units['apparent_temperature_max']}",
                        min: "#{daily_data['apparent_temperature_min'][i]}#{daily_units['apparent_temperature_max']}")
    end
  end

  def fetch_temp_token
    body = {
      expires: Time.zone.now + 59.minutes,
      scopes: []
    }.to_json

    response = self.class.post("/tokens/v2/#{ENV['MAPBOX_USERNAME']}?access_token=#{ENV['MAPBOX_APIKEY']}",
                               { body:,
                                 headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } })

    return unless response.success?

    JSON.parse(response.body)['token']
  end
end
