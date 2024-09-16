import classNames from "classnames";
import { useForecast } from "../hooks/use-forecast";
import { WeatherLocation } from "../models/weather-location";

export const ForecastResults = ({
  weatherLocation,
}: {
  weatherLocation: WeatherLocation;
}) => {
  const { data, error, isLoading } = useForecast(weatherLocation);

  if (isLoading) {
    return <LoadingSkeleton />;
  }

  if (error || !data) {
    return <ForecastError />;
  }

  return (
    <div className="flex flex-row gap-6 justify-center">
      {data.map((v, i) => {
        return (
          <ForecastResult
            key={i}
            day={v.day}
            max={v.max}
            min={v.min}
            isCurrentDay={v.isCurrentDay}
            isSunny={v.isSunny}
          />
        );
      })}
    </div>
  );
};

const ForecastResult = ({
  day,
  max,
  min,
  isCurrentDay,
}: {
  day: string;
  max: string;
  min: string;
  isSunny: boolean;
  isCurrentDay: boolean;
}) => {
  const classes = classNames("flex flex-col gap-2", {
    highlight: isCurrentDay,
  });
  return (
    <div className={classes}>
      <div>{day}</div>
      <div>max: {max}</div>
      <div>min: {min}</div>
    </div>
  );
};

const LoadingSkeleton = () => {
  return <></>;
};
const ForecastError = () => {
  return <></>;
};
