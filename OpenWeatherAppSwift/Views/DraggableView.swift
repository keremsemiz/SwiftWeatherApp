//
//  DraggableView.swift
//  OpenWeatherAppSwift
//
//  Created by Kerem Semiz on 26.06.24.
//
import SwiftUI

struct DraggableSection: View {
    @Binding var isExpanded: Bool
    @State private var offset: CGFloat = 0
    
    var weather: ResponseBody

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Weather now")
                    .bold()
                    .padding()
                
                HStack {
                    WeatherRow(logo: "thermometer", name: "Min. temp", value: weather.main.tempMin.roundDouble() + "°")
                    Spacer()
                    WeatherRow(logo: "thermometer", name: "Max. temp", value: weather.main.tempMax.roundDouble() + "°")
                }
                .padding()
                
                HStack {
                    WeatherRow(logo: "wind", name: "Wind speed", value: weather.wind.speed.roundDouble() + " m/s")
                    Spacer()
                    WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                }
                .padding()
                if isExpanded {
                    // Add additional details here, like hourly and daily forecasts
                    Text("Hourly Forecast")
                        .font(.headline)
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack {
                            HStack {
                                WeatherRow(logo: "thermometer", name: "Min. temp", value: weather.main.tempMin.roundDouble() + "°")
                                Spacer()
                                WeatherRow(logo: "thermometer", name: "Max. temp", value: weather.main.tempMax.roundDouble() + "°")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Daily Forecast")
                        .font(.headline)
                        .padding(.top)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            // Add your daily forecast view here
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .shadow(radius: 10)
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.offset = value.translation.height
                    }
                    .onEnded { value in
                        withAnimation {
                            if self.offset < -100 {
                                self.isExpanded = true
                                self.offset = -200 // or some appropriate value
                            } else {
                                self.isExpanded = false
                                self.offset = 0
                            }
                        }
                    }
            )
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
    }
    
}

struct DraggableSection_Previews: PreviewProvider {
    static var previews: some View {
        DraggableSection(isExpanded: .constant(false), weather: previewWeather)
    }
}
