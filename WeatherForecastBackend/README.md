# Weather Forecast Backend

This app serves as a backend for a Weather Forecast. This rails app serves 2 key endnpoints that are expected from the Frontend app:

- Bootstrap: This endpoint serves as a way to provide initialization information to the frontend. The key information here is the Mapbox token. For the sake of security,
  the backend is responsible for generating a temporary token every time this endpoint is called. This ensures that there are no long lived tokens that are made public. Instead only short live tokens are ever sent to the frontend
- Forecast: This endpoint receives a zip code, latitude and longitude and it returns the forecast for 7 days. The response also includes whether the data was fresh or cached. The data is cached by zip code with expiration of 30 minutes

## Dependencies

- Redis: Forecasted data is cached in redis by zipcode with an expiration of 30 minutes, this should reduce the number of outgoing calls to the open-meteo service.
- MapBox: MapBox is used primarily by the frontend to perform the search of address allowing the user to enter an address and get the zip code, latitude and longitude for the given address. The backend is responsible for retrieving a temporary access token from mapbox and sending that back to the client
- OpenMeteo: This service provides the actual forecast data, only a subset of information is used from their API but this can easily be extended to provide more features to the end user

## Communication with Frontend

- Initially this project does not implement any type of authentication
- JSON is used for both request payloads and responses

## Usage

### Requirements:

- Docker
- Mapbox Account
