import { createApiClient } from "./api-client";

type EnvResponse = {
  mapboxKey: string;
};

export const fetchBootstrapData = () => {
  const client = createApiClient();
  return client.get<EnvResponse>("/v1/bootstrap");
};
