//
//  ContentView.swift
//  WeatherAppSKY
//
//  Created by Ashot Harutyunyan on 2024-03-19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    @State private var weather: WeatherResponse?
    @State private var city: String = "London"
    @State private var isLoading = true
    @State private var showingSideMenu = false
    @State private var showingAddLocationView = false
    @State private var locations: [String] = ["London", "New York", "Tokyo"]

    private let apiKey = "2e0c634311bb50a55aa1e01c3ae5198f"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showingSideMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .padding()
                        }

                        Spacer()

                        Button(action: {
                            showingAddLocationView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .padding()
                        }
                    }
                    .padding(.top, geometry.safeAreaInsets.top)
                    .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 20) {
                            TextField("Enter city name", text: $city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .onSubmit {
                                    fetchWeatherData()
                                }

                            if isLoading {
                                ProgressView()
                            } else if let weather = weather {
                                VStack(spacing: 20) {
                                    Text(city)
                                        .font(.largeTitle)
                                        .bold()

                                    Text("\(weather.main.temp, specifier: "%.1f")°C")
                                        .font(.system(size: 70))
                                        .bold()

                                    Text(weather.weather.first?.main ?? "")
                                        .font(.title)
                                }
                                .foregroundColor(.white)
                                .padding()

                                if let hourlyWeather = weather.hourly {
                                    ForEach(hourlyWeather.prefix(10), id: \.dt) { hour in
                                        HourlyWeatherCell(hour: dateFormatter.string(from: Date(timeIntervalSince1970: hour.dt)), temperature: hour.temp)
                                    }
                                }
                            }
                        }
                    }
                }

                if showingSideMenu {
                    SideMenuView(isShowing: $showingSideMenu, locations: $locations)
                }
            }
            .onAppear {
                fetchWeatherData()
            }
            .onChange(of: viewModel.userSession) {
                           showingSideMenu = false
                       }
        }
        .sheet(isPresented: $showingAddLocationView) {
            AddLocationView(locations: $locations)
        }
    }

    func fetchWeatherData() {
        isLoading = true
        let formattedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            isLoading = false
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
            print("Fetch successfully: \(data)")
            if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.weather = decodedResponse
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
