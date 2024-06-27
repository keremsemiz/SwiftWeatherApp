//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Kerem Semiz on 25.06.24.
//
import Foundation
import CoreLocation

class WeatherManager {
    private let apiKey = "8fd3ee16a35404b103a491eef38a549e"
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else {
            fatalError("Missing URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }
    
    func getWeatherByCity(city: String) async throws -> ResponseBody {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&appid=\(apiKey)&units=metric") else {
            fatalError("Missing URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }
    
    func getHourlyForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> HourlyForecastResponse {
        guard let url = URL(string: "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else {
            fatalError("Missing URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        let decodedData = try JSONDecoder().decode(HourlyForecastResponse.self, from: data)
        return decodedData
    }
}

// ResponseBody and other related struct definitions remain the same.

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}

struct HourlyForecastResponse: Codable {
    var list: [HourlyWeather]
    var city: City
}

struct HourlyWeather: Codable {
    var dt: Int
    var dtTxt: String
    var main: Main
    var weather: [Weather]
    var clouds: Clouds
    var wind: Wind
    var visibility: Int
    var pop: Double
    var rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt
        case dtTxt = "dt_txt"
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case rain
    }
}

struct Main: Codable {
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var pressure: Int
    var humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Clouds: Codable {
    var all: Int
}

struct Wind: Codable {
    var speed: Double
    var deg: Int
}

struct Rain: Codable {
    var oneH: Double?

    enum CodingKeys: String, CodingKey {
        case oneH = "1h"
    }
}

struct City: Codable {
    var name: String
    var coord: Coordinates
    var country: String
}

struct Coordinates: Codable {
    var lat: Double
    var lon: Double
}
