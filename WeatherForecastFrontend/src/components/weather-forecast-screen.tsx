import { useState } from "react";
import { useBootstrap } from "../hooks/use-bootstrap";
import { SearchAddress } from "./search-address";
import { ForecastResults } from "./forecast-results";
import { LoadingScreen } from "./loading-screen";

export const WeatherForecastScreen = () => {
  const [zipCode, setZipCode] = useState<string>("");

  const handleAddressChange = (zipCode: string) => {
    console.log(zipCode);
    setZipCode(zipCode);
  };

  const { data: bootstrapData, error, isLoading } = useBootstrap();

  if (isLoading) {
    return <LoadingScreen />;
  }
  // TODO: Add error handling
  return (
    <div className="flex flex-col gap-4">
      <div className="block text-center">
        <h1 className="text-4xl font-bold">Weather Forecast</h1>
      </div>

      <SearchAddress
        mapboxKey={bootstrapData?.mapboxKey || ""}
        onZipcodeChange={handleAddressChange}
      />
      {zipCode ? <ForecastResults></ForecastResults> : null}
    </div>
  );
};
