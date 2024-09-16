import { useState } from "react";
import { useBootstrap } from "../hooks/use-bootstrap";
import { SearchAddress } from "./search-address";
import { ForecastResults } from "./forecast-results";
import { LoadingScreen } from "./loading-screen";
import { WeatherLocation } from "../models/weather-location";

export const WeatherForecastScreen = () => {
  const [weatherLocation, setWeatherLocation] =
    useState<WeatherLocation | null>(null);

  const handleLocationChange = (newLocation: WeatherLocation) => {
    setWeatherLocation(newLocation);
  };

  const { data: bootstrapData, error, isLoading } = useBootstrap();

  if (isLoading) {
    return <LoadingScreen />;
  }
  // TODO: Add error handling. Show toast if bootstrap data not available
  return (
    <div className="flex flex-col gap-8 items-center">
      <div className="block text-center">
        <h1 className="text-4xl font-bold">Weather Forecast</h1>
      </div>

      <SearchAddress
        mapboxKey={bootstrapData?.mapboxKey || ""}
        onLocationChange={handleLocationChange}
      />
      {weatherLocation ? (
        <ForecastResults weatherLocation={weatherLocation}></ForecastResults>
      ) : null}
    </div>
  );
};
