module Helpers
module ApiHelpers
    def parsed_response
        JSON.parse(response.body).with_indifferent_access
    end
end
end
