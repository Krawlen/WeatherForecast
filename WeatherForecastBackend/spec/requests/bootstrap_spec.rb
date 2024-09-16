# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bootstraps', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:mapbox_username) { 'test_user' }
  let(:mapbox_key) { 'random_value' }

  describe 'GET /show' do
    around do |ex|
      freeze_time do
        ex.run
      end
    end
    before do
      stub_const('ENV', { 'MAPBOX_USERNAME' => mapbox_username, 'MAPBOX_APIKEY' => mapbox_key })

      stub_request(:post, "https://api.mapbox.com/tokens/v2/#{mapbox_username}?access_token=#{mapbox_key}")
        .with(
          body: "{\"expires\":\"#{(Time.zone.now + 59.minutes).iso8601}\",\"scopes\":[]}",
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: expected_status, body: { token: expected_token }.to_json, headers: {})
    end
    subject { get '/v1/bootstrap' }
    context 'when mapbox API responds successfully' do
      let(:expected_token) { 'map_token' }
      let(:expected_status) { 200 }

      it 'includes the public mapbox api key' do
        subject
        expect(parsed_response).to have_key(:mapbox_key)
        expect(parsed_response[:mapbox_key]).to eql expected_token
      end
    end
    context 'when mapbox API fails' do
      let(:expected_token) { 'map_token' }
      let(:expected_status) { 500 }

      it 'returns a parsed error to the client' do
        subject
        expect(response).to be_successful
        expect(parsed_response).to have_key(:error)
      end
    end
  end
end
