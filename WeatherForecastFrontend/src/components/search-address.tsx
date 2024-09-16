import { Geocoder } from "@mapbox/search-js-react";
import { FormEvent, useState } from "react";
import { WeatherLocation } from "../models/weather-location";

export const SearchAddress = ({
  onLocationChange,
  mapboxKey,
}: {
  onLocationChange: (location: WeatherLocation) => void;
  mapboxKey: string;
}) => {
  const [search, setSearch] = useState<string>("");
  const [topSuggestion, setTopSuggestion] = useState<GeocodingResponse | null>(
    null,
  );

  const handleSearchChange = (d: string) => {
    setSearch(d);
  };
  const onFormSubmit = (e: FormEvent) => {
    e.preventDefault();
    const location = topSuggestion
      ? geocodeResponseToLocation(topSuggestion)
      : null;
    if (location) {
      setSearch(location.fullAddress);
      handleSuggestionPicked(topSuggestion);
    } else {
      // TODO: Show toast asking for a new address. Maybe clear the search?
    }
  };

  const handleSuggestionPicked = (suggestion: GeocodingResponse | null) => {
    const location = geocodeResponseToLocation(suggestion);
    if (location) {
      onLocationChange(location);
    } else {
      // TODO: Show toast asking for a new address. Maybe clear the search?
    }
  };

  return (
    <form onSubmit={onFormSubmit} id="weather-form">
      <div className="flex flex-row justify-center gap-2 items-center">
        <label htmlFor="search">Enter Address:</label>

        <Geocoder
          value={search}
          onChange={handleSearchChange}
          onSuggest={(res) => {
            if (res.features[0]) {
              setTopSuggestion(res.features[0]);
            }
          }}
          onRetrieve={(res) => {
            handleSuggestionPicked(res);
          }}
          accessToken={mapboxKey}
        />
      </div>
    </form>
  );
};

interface GeocodingResponse {
  properties: {
    coordinates?: {
      latitude: number;
      longitude: number;
    };
    context: {
      postcode?: {
        name: string;
      };
    };
    full_address: string;
  };
}

const geocodeResponseToLocation = (
  res: GeocodingResponse | null,
): WeatherLocation | null => {
  if (res) {
    const fullAddress = res.properties.full_address;
    const latitude = res?.properties?.coordinates?.latitude;
    const longitude = res?.properties?.coordinates?.longitude;
    const zipCode = res?.properties?.context?.postcode?.name;

    if (fullAddress && latitude && longitude && zipCode) {
      return {
        fullAddress,
        latitude,
        longitude,
        zipCode,
      };
    }
  }
  return null;
};
