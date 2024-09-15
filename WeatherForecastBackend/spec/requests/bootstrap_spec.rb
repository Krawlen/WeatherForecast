require 'rails_helper'

RSpec.describe "Bootstraps", type: :request do
  describe "GET /show" do
    it "includes the public mapbox api key" do
      get "/bootstrap"
      expect(parsed_response).to have_key(:mapbox_key)
    end
  end
end
