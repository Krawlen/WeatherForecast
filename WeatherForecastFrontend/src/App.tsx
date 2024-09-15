import { QueryClient, QueryClientProvider } from "react-query";
import { WeatherForecastScreen } from "./components/weather-forecast-screen";

function App() {
  const queryClient = new QueryClient();

  return (
    <QueryClientProvider client={queryClient}>
      <WeatherForecastScreen></WeatherForecastScreen>
    </QueryClientProvider>
  );
}

export default App;
