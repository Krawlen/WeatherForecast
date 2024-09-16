import { useQuery } from "react-query";
import { fetchForecast } from "../services/forecast";
import { WeatherLocation } from "../models/weather-location";

export const useForecast = (location: WeatherLocation) => {
  const { isLoading, error, data } = useQuery({
    queryKey: ["forecast", location.zipCode],
    queryFn: () => fetchForecast(location).then((res) => res.data.data),
  });

  return { isLoading, error, data };
};
