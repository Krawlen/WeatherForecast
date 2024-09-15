import { Geocoder } from "@mapbox/search-js-react";
import { FormEvent, useState } from "react";

type Suggestion = {
  fullAddress: string | undefined;
  zipcode: string | undefined;
};

export const SearchAddress = ({
  onZipcodeChange,
  mapboxKey,
}: {
  onZipcodeChange: (zipcode: string) => void;
  mapboxKey: string;
}) => {
  const [search, setSearch] = useState<string>("");
  const [topSuggestion, setTopSuggestion] = useState<Suggestion>({
    fullAddress: "",
    zipcode: "",
  });

  const handleSearchChange = (d: string) => {
    setSearch(d);
  };
  const onFormSubmit = (e: FormEvent) => {
    e.preventDefault();
    setSearch(topSuggestion.fullAddress || "");
    handleSuggestionPicked(topSuggestion);
  };

  const handleSuggestionPicked = (suggestion: Suggestion) => {
    if (suggestion.zipcode) {
      onZipcodeChange(suggestion.zipcode);
    } else {
      // Show toast asking for a new address
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
              setTopSuggestion({
                fullAddress: res.features[0].properties.full_address,
                zipcode: res.features[0].properties.context.postcode?.name,
              });
            }
          }}
          onRetrieve={(res) => {
            handleSuggestionPicked({
              zipcode: res.properties.context.postcode?.name,
              fullAddress: res.properties.full_address,
            });
          }}
          accessToken={mapboxKey}
        />
      </div>
    </form>
  );
};
