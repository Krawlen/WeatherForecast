import classNames from "classnames";
import { useForecast } from "../hooks/use-forecast";
import { WeatherLocation } from "../models/weather-location";
import {
  WiCloud,
  WiCloudy,
  WiDayFog,
  WiDayRain,
  WiDayRainWind,
  WiDayShowers,
  WiDaySnow,
  WiDaySunny,
  WiDaySunnyOvercast,
  WiDayThunderstorm,
} from "react-icons/wi";
import { IconType } from "react-icons";

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
    <div className="flex flex-nowrap flex-row gap-6 justify-center overflow-x-auto w-screen mx-10">
      {data.map((v, i) => {
        return (
          <ForecastResult
            key={i}
            time={v.time}
            max={v.max}
            min={v.min}
            weatherCode={v.weatherCode}
          />
        );
      })}
    </div>
  );
};

const ForecastResult = ({
  time,
  max,
  min,
  weatherCode,
}: {
  time: string;
  max: string;
  min: string;
  weatherCode: number;
}) => {
  const dailyWeatherSummary = WMO_CODES[weatherCode];
  const WeatherIcon = dailyWeatherSummary.icon;
  const date = new Date(time);
  const isCurrentDay = new Date().getDate() == date.getDate();
  const weatherContainerCls = classNames(
    "shadow-lg shrink flex-auto rounded-lg",
    {
      "outline outline-4 outline-blue-500": isCurrentDay,
    },
  );
  const currentDayOfWeek = daysOfWeek[date.getDay()];
  return (
    <div
      className={weatherContainerCls}
      style={{ backgroundColor: dailyWeatherSummary.color }}
    >
      <div className="flex flex-col gap-2 items-center">
        <div className="text-center">{currentDayOfWeek}</div>
        <WeatherIcon className="lg:text-9xl md:text-6xl sm:text-2xl" />
        <div className="flex flex-row gap-2 justify-center">
          <div className="text-sm font-bold">{max}</div>
          <div className="text-sm">{min}</div>
        </div>
        <div className="text-center">{dailyWeatherSummary.description}</div>
      </div>
    </div>
  );
};

const daysOfWeek = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
];

const LoadingSkeleton = () => {
  return <></>;
};
const ForecastError = () => {
  return <></>;
};

type VisualWeatherSummary = {
  color: string;
  description: string;
  icon: IconType;
};

const wmoSummary = (
  color: string,
  description: string,
  icon: IconType,
): VisualWeatherSummary => {
  return { color, description, icon };
};

export const WMO_CODES: Record<number, VisualWeatherSummary> = {
  0: wmoSummary("#F1F1F1", "Clear", WiDaySunny),

  1: wmoSummary("#E2E2E2", "Mostly Clear", WiDaySunnyOvercast),
  2: wmoSummary("#C6C6C6", "Partly Cloudy", WiCloudy),
  3: wmoSummary("#ABABAB", "Overcast", WiCloud),

  45: wmoSummary("#A4ACBA", "Fog", WiDayFog),
  48: wmoSummary("#8891A4", "Icy Fog", WiDayFog),

  51: wmoSummary("#3DECEB", "Light Drizzle", WiDayShowers),
  53: wmoSummary("#0CCECE", "Drizzle", WiDayShowers),
  55: wmoSummary("#0AB1B1", "Heavy Drizzle", WiDayShowers),

  80: wmoSummary("#9BCCFD", "Light Showers", WiDayRain),
  81: wmoSummary("#51B4FF", "Showers", WiDayRain),
  82: wmoSummary("#029AE8", "Heavy Showers", WiDayRainWind),

  61: wmoSummary("#BFC3FA", "Light Rain", WiDayRain),
  63: wmoSummary("#9CA7FA", "Rain", WiDayRain),
  65: wmoSummary("#748BF8", "Heavy Rain", WiDayRainWind),

  56: wmoSummary("#D3BFE8", "Light Freezing Drizzle", WiDayShowers),
  57: wmoSummary("#A780D4", "Freezing Drizzle", WiDayShowers),

  66: wmoSummary("#CAC1EE", "Light Freezing Rain", WiDayShowers),
  67: wmoSummary("#9486E1", "Freezing Rain", WiDayShowers),

  71: wmoSummary("#F9B1D8", "Light Snow", WiDaySnow),
  73: wmoSummary("#F983C7", "Snow", WiDaySnow),
  75: wmoSummary("#F748B7", "Heavy Snow", WiDaySnow),

  77: wmoSummary("#E7B6EE", "Snow Grains", WiDaySnow),

  85: wmoSummary("#E7B6EE", "Light Snow Showers", WiDaySnow),
  86: wmoSummary("#CD68E0", "Snow Showers", WiDaySnow),

  95: wmoSummary("#525F7A", "Thunderstorm", WiDayThunderstorm),

  96: wmoSummary("#3D475C", "Light T-storm with Hail", WiDayThunderstorm),
  99: wmoSummary("#2A3140", "T-storm w/ Hail", WiDayThunderstorm),
};
