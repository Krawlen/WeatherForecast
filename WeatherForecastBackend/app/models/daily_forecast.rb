# Represents the forecast for a single day
class DailyForecast
  attr_accessor :time, :weather_code, :max, :min

  def initialize(time:, weather_code:, max:, min:)
    @time = time
    @weather_code = weather_code
    @max = max
    @min = min
  end
end
