require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  describe 'POST /v1/forecast' do
    let(:zip_code) { 92_105 }
    let(:latitude) { 32.77051 }
    let(:longitude) { -117.18759 }
    let(:successful_response) do
      {
        "latitude": 32.76685,
        "longitude": -117.19567,
        "generationtime_ms": 0.932931900024414,
        "utc_offset_seconds": 0,
        "timezone": 'GMT',
        "timezone_abbreviation": 'GMT',
        "elevation": 72,
        "daily_units": {
          "time": 'iso8601',
          "apparent_temperature_max": '°C',
          "apparent_temperature_min": '°C',
          "weather_code": 'wmo code'
        },
        "daily": {
          "time": %w[
            2024-09-16
            2024-09-17
            2024-09-18
            2024-09-19
            2024-09-20
            2024-09-21
            2024-09-22
          ],
          "apparent_temperature_max": [20.8, 21.1, 20.2, 21.3, 22.8, 27.6, 28.6],
          "apparent_temperature_min": [17.4, 12.8, 17.7, 17.8, 18.2, 20.1, 22.4],
          "weather_code": [53, 3, 2, 51, 1, 0, 0]
        }
      }.to_json
    end

    subject do
      post '/v1/forecast', params: { zip_code:, latitude:, longitude: }
    end

    before do
      stub_request(:get, "https://api.open-meteo.com/v1/forecast?daily=apparent_temperature_max,apparent_temperature_min,weather_code&forecast_days=7&latitude=#{latitude}&longitude=#{longitude}")
        .to_return(status: 200, body: successful_response, headers: {})
    end

    context 'when the upstream service is succesful' do
      it 'uses the correct response structure' do
        subject
        expect(parsed_response).to have_key(:data)
        expect(parsed_response[:data]).to have_key(:forecasted_days)
        expect(parsed_response[:data]).to have_key(:is_from_cache)
      end
    end

    context 'when the upstream service fails' do
      before do
        stub_request(:get, "https://api.open-meteo.com/v1/forecast?daily=apparent_temperature_max,apparent_temperature_min,weather_code&forecast_days=7&latitude=#{latitude}&longitude=#{longitude}")
          .to_return(status: 500, body: '', headers: {})
      end
      it 'uses the correct response structure' do
        subject
        expect(parsed_response).to have_key(:errors)
      end
    end

    context 'when the zipcode is missing' do
      let(:zip_code) { nil }

      it 'returns an error' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'includes the cause in the error' do
        subject
        expect(parsed_response).to have_key(:errors)
        expect(parsed_response[:errors]).to have_key(:zip_code)
        expect(parsed_response[:errors][:zip_code]).to include("can't be blank")
      end
    end
    context 'when the latitude is missing' do
      let(:latitude) { nil }

      it 'returns an error' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'includes the cause in the error' do
        subject
        expect(parsed_response).to have_key(:errors)
        expect(parsed_response[:errors]).to have_key(:latitude)
        expect(parsed_response[:errors][:latitude]).to include("can't be blank")
      end
    end

    context 'when the longitude is missing' do
      let(:longitude) { nil }

      it 'returns an error' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'includes the cause in the error' do
        subject
        expect(parsed_response).to have_key(:errors)
        expect(parsed_response[:errors]).to have_key(:longitude)
        expect(parsed_response[:errors][:longitude]).to include("can't be blank")
      end
    end
  end
end
