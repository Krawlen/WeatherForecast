# frozen_string_literal: true

module V1
  class BootstrapController < ApplicationController
    def show
      token = MapboxService.new.fetch_temp_token
      if token
        render json: {
          mapbox_key: token
        }
      else
        render json: { error: 'Upstream service is unavailable. Try again later' }
      end
    end
  end
end
