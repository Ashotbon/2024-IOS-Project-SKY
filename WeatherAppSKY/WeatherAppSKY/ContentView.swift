//
//  ContentView.swift
//  WeatherAppSKY
//
//  Created by Ashot Harutyunyan on 2024-03-19.
//

import SwiftUI

struct ContentView: View {
    @State private var weather: WeatherResponse?
    @State private var city: String = "Laval"
    @State private var isLoading = true

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    TextField("Enter city name", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit {
                            fetchWeatherData()
                        }

                    if let weather = weather {
                        VStack(spacing: 20) {
                            Text(city)
                                .font(.largeTitle)
                                .bold()

                            Text("\(weather.main.temp, specifier: "%.0f")°C")
                                .font(.system(size: 70))
                                .bold()

                            Text("\(weather.weather[0].main)")
                                .font(.title)
                        }
                        .foregroundColor(.white)
                        .padding()

//                        if let coord = weather.coord {
//                            let mapURL = URL(string: "https://openweathermap.org/weathermap?basemap=map&cities=false&layer=clouds&lat=\(coord.lat)&lon=\(coord.lon)&zoom=10")!
//                            WebView(url: mapURL)
//                                .frame(height: 200)
//                                .cornerRadius(10)
//                                .padding()
//                        }
                    } else if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Enter a city name to view the weather")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
            }
        }
        .onAppear {
            fetchWeatherData()
        }
    }

    func fetchWeatherData() {
        isLoading = true
        let apiKey = "2e0c634311bb50a55aa1e01c3ae5198f"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) // Handle cities with spaces or special characters

        guard let url = URL(string: urlString!) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.weather = decodedResponse
                        self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }.resume()
    }
}

struct WeatherResponse: Codable {
    var coord: Coord?
    var main: Main
    var weather: [Weather]
}

struct Coord: Codable {
    var lon: Double
    var lat: Double
}

struct Main: Codable {
    var temp: Double
}

struct Weather: Codable {
    var main: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

