import axios from "axios";
import applyCaseMiddleware from "axios-case-converter";

export const createApiClient = () => {
  return applyCaseMiddleware(
    axios.create({
      baseURL: import.meta.env.VITE_BACKEND_URL,
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    }),
  );
};
