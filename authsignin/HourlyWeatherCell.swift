//
//  HourlyWeatherCell.swift
//  WeatherApp
//
//  Created by Ashot Harutyunyan on 2024-03-18.
//
import SwiftUI

struct HourlyWeatherCell: View {
    let hour: String
    let temperature: Double

    var body: some View {
        HStack {
            Text(hour)
                .foregroundColor(.white)
                .font(.title)
            Spacer()
            Text("\(temperature, specifier: "%.1f")°C")
                .foregroundColor(.white)
                .font(.title)
        }
        .padding(.horizontal)
    }
}
