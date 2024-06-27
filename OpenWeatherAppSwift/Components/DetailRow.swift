//
//  WeatherRow.swift
//  SwiftWeatherApp
//
//  Created by Kerem Semiz on 27.06.24.
//

import SwiftUI

struct DetailRow: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View{
        VStack(spacing: 20) {
            Text(name)
                .font(.caption)
            Image(systemName: logo)
                .font(.title)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)
            Text(value)
                .bold()
                .font(.headline)
        }
        .padding()
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white)
        )
        .preferredColorScheme(.dark)
    }
}

struct DetailRow_Previews: PreviewProvider {
    static var previews: some View {
        DetailRow(logo: "sun.max", name: "17:00", value: "8°")
    }
}
