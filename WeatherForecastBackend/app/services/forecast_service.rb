# frozen_string_literal: true

class ForecastService
  include HTTParty
  base_uri 'https://api.open-meteo.com/'

  def fetch_forecast(zip_code)
    results.first.coordinates
    self.class.get('/v1/forecast', { query: {
                     latitude: results.latitude,
                     longitude: results.longitude,
                     daily: weather_code,
                     timezone: results.timezone
                   } })
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
