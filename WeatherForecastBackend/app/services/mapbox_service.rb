class MapboxService
  include HTTParty
  base_uri "https://api.mapbox.com"




  def get_temp_token
    body = {
      expires: Time.zone.now + 59.minutes,
      scopes: []
  }.to_json

    response = self.class.post("/tokens/v2/#{ENV["MAPBOX_USERNAME"]}?access_token=#{ENV["MAPBOX_APIKEY"]}", { body: body, headers: { "Content-Type" => "application/json", "Accept" => "application/json" } })

    if response.success?
      JSON.parse(response.body)["token"]
    end
  end
end
