//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Kerem Semiz on 25.06.24.
//
import Foundation
import CoreLocation

class WeatherManager {
    private let apiKey = "bfc2796091f045f19e5103011242906"
    
    func getCurrentWeather(city: String) async throws -> CurrentWeatherResponse {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        guard let url = URL(string: "http://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityQuery)") else {
            fatalError("Missing URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        let decodedData = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
        return decodedData
    }
    
    func getHourlyForecast(city: String) async throws -> HourlyForecastResponse {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        guard let url = URL(string: "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(cityQuery)&days=1&hourly=1") else {
            fatalError("Missing URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        let decodedData = try JSONDecoder().decode(HourlyForecastResponse.self, from: data)
        return decodedData
    }
    
    func getDailyForecast(city: String, days: Int) async throws -> DailyForecastResponse {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        guard let url = URL(string: "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(cityQuery)&days=\(days)") else {
            fatalError("Missing URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        let decodedData = try JSONDecoder().decode(DailyForecastResponse.self, from: data)
        return decodedData
    }
}

// ResponseBody and other related struct definitions remain the same.

struct CurrentWeatherResponse: Codable {
    var location: Location
    var current: Current
}

struct HourlyForecastResponse: Codable {
    var location: Location
    var forecast: Forecast
}

struct DailyForecastResponse: Codable {
    var location: Location
    var forecast: Forecast
}

struct Location: Codable {
    var name: String
    var region: String
    var country: String
    var lat: Double
    var lon: Double
    var tz_id: String
    var localtime_epoch: Int
    var localtime: String
}

struct Current: Codable {
    var temp_c: Double
    var temp_f: Double
    var is_day: Int
    var condition: Condition
    var wind_mph: Double
    var wind_kph: Double
    var wind_degree: Int
    var wind_dir: String
    var pressure_mb: Double
    var pressure_in: Double
    var precip_mm: Double
    var precip_in: Double
    var humidity: Int
    var cloud: Int
    var feelslike_c: Double
    var feelslike_f: Double
    var vis_km: Double
    var vis_miles: Double
    var uv: Double
    var gust_mph: Double
    var gust_kph: Double
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    var date: String
    var date_epoch: Int
    var day: Day
    var astro: Astro
    var hour: [Hour]
}

struct Day: Codable {
    var maxtemp_c: Double
    var maxtemp_f: Double
    var mintemp_c: Double
    var mintemp_f: Double
    var avgtemp_c: Double
    var avgtemp_f: Double
    var maxwind_mph: Double
    var maxwind_kph: Double
    var totalprecip_mm: Double
    var totalprecip_in: Double
    var avgvis_km: Double
    var avgvis_miles: Double
    var avghumidity: Int
    var daily_will_it_rain: Int
    var daily_chance_of_rain: Int
    var daily_will_it_snow: Int
    var daily_chance_of_snow: Int
    var condition: Condition
    var uv: Double
}

struct Astro: Codable {
    var sunrise: String
    var sunset: String
    var moonrise: String
    var moonset: String
    var moon_phase: String
    var moon_illumination: String
}

struct Hour: Codable {
    var time_epoch: Int
    var time: String
    var temp_c: Double
    var temp_f: Double
    var is_day: Int
    var condition: Condition
    var wind_mph: Double
    var wind_kph: Double
    var wind_degree: Int
    var wind_dir: String
    var pressure_mb: Double
    var pressure_in: Double
    var precip_mm: Double
    var precip_in: Double
    var humidity: Int
    var cloud: Int
    var feelslike_c: Double
    var feelslike_f: Double
    var windchill_c: Double
    var windchill_f: Double
    var heatindex_c: Double
    var heatindex_f: Double
    var dewpoint_c: Double
    var dewpoint_f: Double
    var will_it_rain: Int
    var chance_of_rain: Int
    var will_it_snow: Int
    var chance_of_snow: Int
    var vis_km: Double
    var vis_miles: Double
    var gust_mph: Double
    var gust_kph: Double
    var uv: Double
}

struct Condition: Codable {
    var text: String
    var icon: String
    var code: Int
}
