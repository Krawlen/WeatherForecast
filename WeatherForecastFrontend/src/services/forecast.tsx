import { WeatherLocation } from "../models/weather-location";
import { createApiClient } from "./api-client";

type ForecastResponse = {
  data: Forecast[];
};

type Forecast = {
  day: string;
  max: string;
  min: string;
  isCurrentDay: boolean;
  isSunny: boolean;
};

export const fetchForecast = (location: WeatherLocation) => {
  const client = createApiClient();
  return client.post<ForecastResponse>("/v1/forecast", {
    zip_code: location.zipCode,
    latitude: location.latitude,
    longitude: location.longitude,
  });
};
