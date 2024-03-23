//
//  AddLocationView.swift
//  WeatherAppSKY
//
//  Created by Ashot Harutyunyan on 2024-03-22.
//

import SwiftUI



struct AddLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var locations: [String]
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var weather: WeatherResponse?

    let apiKey = "2e0c634311bb50a55aa1e01c3ae5198f"

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Enter the city or zip code")
                    .padding()
//
//                Button("Fetch Weathersss") {
//                    print("Fetching weather for city: \(searchText)")
//                    fetchWeatherData()
//                }
//                .padding()
//                .disabled(searchText.isEmpty)
//
//                if isLoading {
//                    ProgressView()
//                } else if let weather = weather {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Weather for \(searchText):")
//                            .font(.headline)
//                        Text("Temperature: \(weather.main.temp, specifier: "%.1f")°C")
//                        Text("Condition: \(weather.weather.first?.main ?? "N/A")")
//                    }
//                    .padding()
//                }
                                Button("Fetch Weathersss") {
                                    print("Fetching weather for city: \(searchText)")
                                    fetchWeatherData()
                                }

                Spacer()
            }
            .navigationBarTitle("Add a new location", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            searchText = ""
        }
    }

    func fetchWeatherData() {
        print("Fetching weather data for: \(searchText)")
        guard !searchText.isEmpty else {
            print("Search text is empty")
            return
        }
        isLoading = true
        let formattedCity = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            isLoading = false
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }
            guard let data = data else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.weather = decodedResponse
                    if !self.locations.contains(self.searchText) {
                        self.locations.append(self.searchText)
                        print("Weather data fetched and city added: \(self.searchText)")
                    }
                }
            } else {
                print("Decoding failed")
            }
        }.resume()
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(locations: .constant(["London", "New York"]))
    }
}

