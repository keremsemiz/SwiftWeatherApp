import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    var hourlyWeather: HourlyForecastResponse?
    @State private var isExpanded = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold()
                        .font(.title)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: iconName(for: weather.weather[0].id))
                                .font(.system(size: 40))
                            
                            Text("\(weather.weather[0].main)")
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    Spacer()
                        .frame(height: 80)
                    
                    AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 40, height: 5, alignment: .leading)
                            .foregroundColor(Color.white)
                            .padding(.top, 5)
                            
                        
                        Text("Weather now")
                            .bold()
                            .padding(.horizontal)
                        
                        HStack {
                            WeatherRow(logo: "thermometer.low", name: "Min. temp", value: weather.main.tempMin.roundDouble() + "°")
                            Spacer()
                            WeatherRow(logo: "thermometer.high", name: "Max. temp", value: weather.main.tempMax.roundDouble() + "°")
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 0)
                        
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind speed", value: weather.wind.speed.roundDouble() + " m/s")
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                        }.padding()
                        
                        if isExpanded {
                            // Add additional details here, like hourly and daily forecasts
                            if let hourlyWeather = hourlyWeather {
                                Text("Hourly Forecast")
                                    .font(.headline)
                                    .padding(.top)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        // Display hourly forecast
                                        ForEach(hourlyWeather.list, id: \.dt) { weather in
                                            DetailRow(logo: "sun.max", name: "\(weather.dt_txt)", value: "\(weather.main.temp.roundDouble())°")
                                                .padding()
                                                .background(Color.white.opacity(0.5))
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Text("Daily Forecast")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    HStack {
                                        WeatherRow(logo: "thermometer", name: "Min. temp", value: weather.main.tempMin.roundDouble() + "°")
                                        Spacer()
                                        WeatherRow(logo: "thermometer", name: "Max. temp", value: weather.main.tempMax.roundDouble() + "°")
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 0)
                                    
                                    HStack {
                                        WeatherRow(logo: "wind", name: "Wind speed", value: weather.wind.speed.roundDouble() + " m/s")
                                        Spacer()
                                        WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                                    }.padding()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .shadow(radius: 10)
                    .offset(y: offset)
                    .frame(height: 1000)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newOffset = value.translation.height
                                if newOffset < 0 {
                                    self.offset = newOffset
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if -value.translation.height > geometry.size.height / 4 {
                                        self.isExpanded = true
                                        self.offset = -geometry.size.height + 800
                                    } else {
                                        self.isExpanded = false
                                        self.offset = 0
                                    }
                                }
                            }
                    )
                    .frame(height: isExpanded ? geometry.size.height * 0.7 : geometry.size.height * 0.3)
                    .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
    }
    
    func iconName(for weatherId: Double) -> String {
        switch weatherId {
        case 200...202:
            return "cloud.bolt.rain"
        case 210...212:
            return "cloud.bolt"
        case 221:
            return "cloud.bolt"
        case 230...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.rain"
        case 511:
            return "snow"
        case 520...531:
            return "cloud.heavyrain"
        case 600...622:
            return "snow"
        case 701:
            return "cloud.fog"
        case 711:
            return "smoke"
        case 721:
            return "sun.haze"
        case 731, 751, 761:
            return "cloud.hail"
        case 741:
            return "cloud.fog"
        case 762:
            return "cloud.hail"
        case 771:
            return "wind"
        case 781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803:
            return "cloud"
        case 804:
            return "cloud.fill"
        default:
            return "questionmark" // unknown weather
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather, hourlyWeather: previewHourlyWeather)
    }
}
