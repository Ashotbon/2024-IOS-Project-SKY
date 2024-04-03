//
//  ContentView.swift
//  Weather
//
//  Created by Ashot Harutyunyan on 2024-03-20.
//

import SwiftUI

struct HourlyWeatherResponse: Codable {
    let list: [HourlyForecast]
}

//struct HourlyForecast: Codable, Identifiable {
//    let dt: Int
//    let main: Main
//    let weather: [Weather]
//    let dt_txt: String
//    
//    var id: Int { dt } // Using the datetime as a unique ID
//}
struct HourlyForecast: Codable, Identifiable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
    
    var id: Int { dt } // Using the datetime as a unique ID

    // Computed property to get the hour
    var hour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust timezone if necessary

        if let date = formatter.date(from: dt_txt) {
            formatter.dateFormat = "HH" // Format for hour
            return formatter.string(from: date)
        }

        return ""
    }
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}


struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    @State private var weather: WeatherResponse?
    @State private var city: String = "London"
    @State private var isLoading = true
    @State private var showingSideMenu = false
    @State private var showingAddLocationView = false
    @State private var locationNames: [String] = []
//    @Published var hourlyWeather: [HourlyForecast] = []
    @State private var hourlyWeather: [HourlyForecast] = []
//    @State private var locations: [String] = ["London", "New York", "Tokyo"]

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

                                    Text("\(weather.main.temp, specifier: "%.0f")°C")
                                        .font(.system(size: 70))
                                        .bold()

                                    Text(weather.weather.first?.main ?? "")
                                        .font(.title)
                                }
                                .foregroundColor(.white)
                                .padding()

                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack {
                                        ForEach(hourlyWeather) { weather in
                                            VStack {
                                                Text("\(weather.hour)h") // Display the hour
                                                Text("\(weather.main.temp, specifier: "%.0f")°C")
                                                Text(weather.weather.first?.description ?? "")
                                                Image(systemName: "cloud") // Ideally, use an appropriate icon based on `weather.weather.icon`
                                            }
                                            .frame(width: 100, height: 100)
                                            .background(Color.gray.opacity(0.3))
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }

         
                if showingSideMenu {
                                  SideMenuView(isShowing: $showingSideMenu)
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
                   AddLocationView(locations: $locationNames)
               }
    }
    func fetchHourlyWeatherData(lat: Double, lon: Double) {
   
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL for hourly weather data")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                print("Fetch failed for hourly weather data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received for hourly weather data")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(HourlyWeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.hourlyWeather = decodedResponse.list
                }
                print("Hourly weather data fetched successfully: \(decodedResponse)")
            } catch {
                print("Decoding failed for hourly weather data: \(error.localizedDescription)")
            }
        }.resume()
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
            
            if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.weather = decodedResponse
                    self.fetchHourlyWeatherData(lat: decodedResponse.coord.lat, lon: decodedResponse.coord.lon)
                    print("Fetch successfully: \(decodedResponse)")
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
