import Foundation

// Example preview data
let previewCurrentWeather = CurrentWeatherResponse(
    location: Location(
        name: "London",
        region: "",
        country: "UK",
        lat: 51.51,
        lon: -0.13,
        tz_id: "Europe/London",
        localtime_epoch: 1661950800,
        localtime: "2023-08-30 16:00"
    ),
    current: Current(
        temp_c: 20.0,
        temp_f: 68.0,
        is_day: 1,
        condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png", code: 1000),
        wind_mph: 5.0,
        wind_kph: 8.0,
        wind_degree: 200,
        wind_dir: "SSW",
        pressure_mb: 1015,
        pressure_in: 30.0,
        precip_mm: 0.0,
        precip_in: 0.0,
        humidity: 50,
        cloud: 0,
        feelslike_c: 20.0,
        feelslike_f: 68.0,
        vis_km: 10.0,
        vis_miles: 6.0,
        uv: 5.0,
        gust_mph: 7.0,
        gust_kph: 12.0
    )
)

// Hourly Weather Data
let hourlyWeatherData: [Hour] = (0..<24).map { hour in
    let baseTempC = 15.0 + Double(hour % 10)
    let baseTempF = 59.0 + Double(hour % 10) * 1.8
    let isDay = hour >= 6 && hour < 18 ? 1 : 0
    let cloudCoverage = hour % 2 == 0 ? 0 : 50
    let gustMph = 7.0 + Double(hour % 5)
    let gustKph = 12.0 + Double(hour % 8)
    
    return Hour(
        time_epoch: 1661950800 + hour * 3600,
        time: "2023-08-30 \(String(format: "%02d", hour)):00",
        temp_c: baseTempC,
        temp_f: baseTempF,
        is_day: isDay,
        condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png", code: 1000),
        wind_mph: 5.0 + Double(hour % 5),
        wind_kph: 8.0 + Double(hour % 8),
        wind_degree: 200,
        wind_dir: "SSW",
        pressure_mb: 1015,
        pressure_in: 30.0,
        precip_mm: 0.0,
        precip_in: 0.0,
        humidity: 50,
        cloud: cloudCoverage,
        feelslike_c: baseTempC,
        feelslike_f: baseTempF,
        windchill_c: baseTempC,
        windchill_f: baseTempF,
        heatindex_c: baseTempC,
        heatindex_f: baseTempF,
        dewpoint_c: 10.0,
        dewpoint_f: 50.0,
        will_it_rain: 0,
        chance_of_rain: 0,
        will_it_snow: 0,
        chance_of_snow: 0,
        vis_km: 10.0,
        vis_miles: 6.0,
        gust_mph: gustMph,
        gust_kph: gustKph,
        uv: 5.0
    )
}

let previewHourlyWeather = HourlyForecastResponse(
    location: previewCurrentWeather.location,
    forecast: Forecast(
        forecastday: [
            ForecastDay(
                date: "2024-06-30",
                date_epoch: 1661950800,
                day: Day(
                    maxtemp_c: 25.0,
                    maxtemp_f: 77.0,
                    mintemp_c: 15.0,
                    mintemp_f: 59.0,
                    avgtemp_c: 20.0,
                    avgtemp_f: 68.0,
                    maxwind_mph: 10.0,
                    maxwind_kph: 16.0,
                    totalprecip_mm: 0.0,
                    totalprecip_in: 0.0,
                    avgvis_km: 10.0,
                    avgvis_miles: 6.0,
                    avghumidity: 50,
                    daily_will_it_rain: 0,
                    daily_chance_of_rain: 0,
                    daily_will_it_snow: 0,
                    daily_chance_of_snow: 0,
                    condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png", code: 1000),
                    uv: 5.0
                ),
                astro: Astro(
                    sunrise: "06:00 AM",
                    sunset: "08:00 PM",
                    moonrise: "10:00 PM",
                    moonset: "06:00 AM",
                    moon_phase: "Waning Crescent",
                    moon_illumination: "25"
                ),
                hour: hourlyWeatherData
            )
        ]
    )
)

// Daily Weather Data
let dailyWeatherData: [ForecastDay] = (0..<7).map { day in
    let date = String(format: "2023-08-%02d", 30 + day)
    let baseTempC = 25.0 + Double(day)
    let baseTempF = 77.0 + Double(day) * 1.8
    let rainChance = day % 3 == 0 ? 70 : 0
    
    return ForecastDay(
        date: date,
        date_epoch: 1661950800 + day * 86400,
        day: Day(
            maxtemp_c: baseTempC,
            maxtemp_f: baseTempF,
            mintemp_c: 15.0 + Double(day),
            mintemp_f: 59.0 + Double(day) * 1.8,
            avgtemp_c: 20.0 + Double(day),
            avgtemp_f: 68.0 + Double(day) * 1.8,
            maxwind_mph: 10.0 + Double(day),
            maxwind_kph: 16.0 + Double(day),
            totalprecip_mm: 0.0,
            totalprecip_in: 0.0,
            avgvis_km: 10.0,
            avgvis_miles: 6.0,
            avghumidity: 50 - day,
            daily_will_it_rain: day % 3 == 0 ? 1 : 0,
            daily_chance_of_rain: rainChance,
            daily_will_it_snow: 0,
            daily_chance_of_snow: 0,
            condition: Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png", code: 1000),
            uv: 5.0
        ),
        astro: Astro(
            sunrise: "06:00 AM",
            sunset: "08:00 PM",
            moonrise: "10:00 PM",
            moonset: "06:00 AM",
            moon_phase: "Waning Crescent",
            moon_illumination: "\(25 + day * 5)"
        ),
        hour: []  // Hour data is not needed for daily forecast
    )
}

let previewDailyWeather = DailyForecastResponse(
    location: previewCurrentWeather.location,
    forecast: Forecast(
        forecastday: dailyWeatherData
    )
)
