//
//  WelcomeView.swift
//  OpenWeatherAppSwift
//
//  Created by Kerem Semiz on 26.06.24.
//
import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var city: String = ""
    @State private var weatherManager = WeatherManager()
    @State private var currentWeather: CurrentWeatherResponse?
    @State private var hourlyWeather: HourlyForecastResponse?
    @State private var dailyWeather: DailyForecastResponse?

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Welcome to the Weather App")
                    .bold()
                    .font(.title)
                
                Text("Please share your current location to get the weather in your area")
                Text("Or search your city!")
                    .padding()
            }
            .multilineTextAlignment(.center)
            .padding()

            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            
            TextField("Enter your city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                Task {
                    await fetchWeather()
                }
            }) {
                Text("Get Weather")
                    .bold()
                    .frame(width: 200, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()

            if let currentWeather = currentWeather, let hourlyWeather = hourlyWeather, let dailyWeather = dailyWeather {
                WeatherView(currentWeather: currentWeather, hourlyWeather: hourlyWeather, dailyWeather: dailyWeather)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func fetchWeather() async {
        do {
            currentWeather = try await weatherManager.getCurrentWeather(city: city)
            hourlyWeather = try await weatherManager.getHourlyForecast(city: city)
            dailyWeather = try await weatherManager.getDailyForecast(city: city, days: 3)
        } catch {
            print("Error fetching weather: \(error)")
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(LocationManager())
    }
}
