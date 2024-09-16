require 'rails_helper'

RSpec.describe ForecastService do
  describe '#fetch_forecast' do
    let(:zip_code) { 92_105 }
    let(:latitude) { 32.77051 }
    let(:longitude) { -117.18759 }
    let(:max_units) { '°C' }
    let(:min_units) { '°C' }
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
          "apparent_temperature_max": max_units,
          "apparent_temperature_min": min_units,
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
    let(:response_double) { double('response', body: response, success?: response_success) }
    let(:response) { successful_response }
    let(:response_success) { true }

    subject { ForecastService.new(zip_code:, latitude:, longitude:) }

    context 'from remote' do
      before do
        allow(Rails.cache).to receive(:fetch).with(anything).and_return(nil)
      end

      it 'requests all the necessary properties' do
        expect(described_class).to receive('get')
          .with('/v1/forecast',
                { query: hash_including({ daily: 'apparent_temperature_max,apparent_temperature_min,weather_code' }) })
          .and_return(response_double)
        subject.fetch_forecast
      end

      it 'returns is_from_cache as false' do
        allow(described_class).to receive('get')
          .with('/v1/forecast',
                { query: hash_including({ daily: 'apparent_temperature_max,apparent_temperature_min,weather_code' }) })
          .and_return(response_double)
        expect(subject.fetch_forecast[:is_from_cache]).to be false
      end

      it 'combines the raw response into an array of DailyForecast' do
        allow(described_class).to receive('get')
          .with('/v1/forecast',
                { query: hash_including({ daily: 'apparent_temperature_max,apparent_temperature_min,weather_code' }) })
          .and_return(response_double)
        forecasted_days = subject.fetch_forecast[:forecasted_days]
        expect(forecasted_days.count).to eql ForecastService::FORECAST_DAYS
        forecasted_days.each do |forecast|
          expect(forecast.time).to be_present
          expect(forecast.weather_code).to be_present
          expect(forecast.max).to include(max_units)
          expect(forecast.min).to include(min_units)
        end
      end

      context 'when the upstream service fails' do
        let(:response_success) { false }
        it 'does not store anything in cache' do
          expect(Rails.cache).to_not receive(:write)
          allow(described_class).to receive('get')
            .and_return(response_double)

          subject.fetch_forecast
        end
      end
    end
    context 'from cache' do
      before do
        allow(Rails.cache).to receive(:fetch).with(anything).and_return(successful_response)
      end

      it 'combines the raw response into an array of DailyForecast' do
        forecasted_days = subject.fetch_forecast[:forecasted_days]
        expect(forecasted_days.count).to eql ForecastService::FORECAST_DAYS
        forecasted_days.each do |forecast|
          expect(forecast.time).to be_present
          expect(forecast.weather_code).to be_present
          expect(forecast.max).to include(max_units)
          expect(forecast.min).to include(min_units)
        end
      end

      it 'returns is_from_cache as true' do
        expect(subject.fetch_forecast[:is_from_cache]).to be true
      end

      it 'never attempts to make a network request' do
        expect(described_class).not_to receive('get')
      end
    end
  end
end
