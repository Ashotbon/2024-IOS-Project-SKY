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
 
 
struct HourlyForecast: Codable, Identifiable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
    
    var id: Int { dt } // Using the datetime as a unique ID
 
    // Computed property to get the hour in "HH:00" format
    var hour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust timezone if necessary
 
        if let date = formatter.date(from: dt_txt) {
            formatter.dateFormat = "HH:00" // Format for hour in "HH:00" format
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
    @StateObject private var locationManager = LocationManager()
    
    @State private var weather: WeatherResponse?
    @State private var city: String = ""
    @State private var isLoading = true
    @State private var showingSideMenu = false
    @State private var showingAddLocationView = false
    @State private var locationNames: [String] = []
    @State private var hourlyWeather: [HourlyForecast] = []
 
 
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
                                    fetchWeatherData(cityName: city)
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
                                                                    Text("\(weather.hour)") // Display the hour
                                                                    Text("\(weather.main.temp, specifier: "%.0f")°C")
                                                                    Text(weather.weather.first?.description ?? "")
                                                                    if let iconName = weather.weather.first?.icon {
                                                                                  Image(iconName) // Load the image from the asset catalog using the icon code
                                                                                      .resizable()
                                                                                      .scaledToFit()
                                                                                      .frame(width: 50, height: 50)
                                                                              } else {
                                                                                  Image(systemName: "questionmark.circle") // Fallback icon
                                                                                      .resizable()
                                                                                      .scaledToFit()
                                                                                      .frame(width: 50, height: 50)
                                                                              }
                                                                        .padding()
                                                                }
                                                                .frame(width: 100, height: 100)
                                                                .background(Color.blue.opacity(0.3))
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
                locationManager.start()
                fetchWeatherData()
            }
            .onChange(of: viewModel.userSession) {
                           showingSideMenu = false 
                       }
            .onChange(of: locationManager.currentLocation) {
                if locationManager.currentLocation != nil {
                    fetchWeatherData()
                }
            }
        }
        .sheet(isPresented: $showingAddLocationView) {
                   AddLocationView(locations: $locationNames)
               }
    }
    func fetchHourlyWeatherData(lat: Double, lon: Double) {
   
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
 
        
        print (urlString)
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
//                print("Hourly weather data fetched successfully: \(decodedResponse)")
            } catch {
                print("Decoding failed for hourly weather data: \(error.localizedDescription)")
            }
        }.resume()
    }



//    func fetchWeatherData() {
//        isLoading = true
//        let formattedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&units=metric&appid=\(apiKey)"
//
//        guard let url = URL(string: urlString) else {
//            isLoading = false
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                isLoading = false
//            }
//            
//            guard let data = data else {
//                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
//                DispatchQueue.main.async {
//                    self.weather = decodedResponse
//                    self.fetchHourlyWeatherData(lat: decodedResponse.coord.lat, lon: decodedResponse.coord.lon)
//                    print("Fetch successfully: \(decodedResponse)")
//                }
//            }
//        }.resume()
//    }
    func fetchWeatherData(cityName: String? = nil) {
        isLoading = true
 
        if let cityName = cityName, !cityName.isEmpty {
            // Fetch weather by city name
            let formattedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&units=metric&appid=\(apiKey)"
 
            fetchData(from: urlString)
        } else if let location = locationManager.currentLocation {
            // Fetch weather by current location coordinates
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
            print(urlString,"meri")
            fetchData(from: urlString)
        } else {
            print("No valid city name or location available.")
            isLoading = false
        }
    }
    private func fetchData(from urlString: String) {
          guard let url = URL(string: urlString) else {
              print("Invalid URL")
              isLoading = false
              return
          }
   
          URLSession.shared.dataTask(with: url) { data, response, error in
              DispatchQueue.main.async {
                  self.isLoading = false
              }
              
              guard let data = data else {
                  print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                  return
              }
              
              if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                  DispatchQueue.main.async {
                      self.weather = decodedResponse
                      self.city = decodedResponse.name
                      
  //                    self.city = decodedResponse.city.name // Update the city name based on the response
                      self.fetchHourlyWeatherData(lat: decodedResponse.coord.lat, lon: decodedResponse.coord.lon)
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
