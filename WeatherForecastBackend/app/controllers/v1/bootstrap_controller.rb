# frozen_string_literal: true

module V1
  class BootstrapController < ApplicationController
    def show
      render json: {
        mapbox_key: MapboxService.new.get_temp_token
      }
    end
  end
end
