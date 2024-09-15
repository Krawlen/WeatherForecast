import { useQuery } from "react-query";
import { fetchBootstrapData } from "../services/bootstrap";

export const useBootstrap = () => {
  const { isLoading, error, data } = useQuery({
    queryKey: ["env"],
    queryFn: () => fetchBootstrapData().then((res) => res.data),
    staleTime: 50 * 60 * 1000, //50  mins
  });

  return { isLoading, error, data };
};
