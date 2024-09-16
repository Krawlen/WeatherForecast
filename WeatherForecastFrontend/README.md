# Weather Forecast Frontend

This app is the frontend for the Weather Forecast app. This is a react app that provides a dynamic experience for users to search the weather forecast for an address. This app _REQUIRES_ the backend project to be able to run successfully.

## Libraries and Dependencies

- [Tailwind](https://tailwindcss.com) A utility-first CSS framework packed with classes like flex, pt-4, text-center and rotate-90 that can be composed to build any design, directly in your markup.

  Tailwind is used to reduce the amount of css needed as well as keep the style consistency across different components

- [Mapbox Geocoding](https://docs.mapbox.com/mapbox-search-js/api/react/geocoding/): Used to build a search box that allows the user to search an address and get the latitude, longitude and zip code back.
  In order to use Mapbox Geocoding an access token is needed. To prevent long-lived access tokens being public the access token is requested directly to the backend that way the frontend does not store/hold the token and the backend can rotate them as needed

## Usage

### Requirements:

- Docker
- Backend app running

### Running the app (in dev)

1. Create a .env file using .env.example as a starting point. Make sure to update the values as needed.
2.
