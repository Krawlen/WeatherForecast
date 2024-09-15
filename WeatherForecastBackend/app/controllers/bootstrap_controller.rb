class BootstrapController < ApplicationController
    def show
        render json: {
            mapbox_key: MapboxService.new.get_temp_token
        }
    end
end
