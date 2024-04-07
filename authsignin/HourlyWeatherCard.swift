
import SwiftUI

//struct HourlyWeatherCell: View {
//    let hour: String
//    let temperature: Double
//
//    var body: some View {
//        HStack {
//            Text(hour)
//                .foregroundColor(.white)
//                .font(.title)
//            Spacer()
//            Text("\(temperature, specifier: "%.0f")°C")
//                .foregroundColor(.white)
//                .font(.title)
//        }.foregroundColor(.white)
//        .padding(.horizontal)
//    }
//}import SwiftUI

struct HourlyWeatherCard: View {
    let weather: HourlyForecast

    var body: some View {
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
        }
        .foregroundColor(.white)
        .frame(width: 80, height: 150) // Adjust width and height here
        .background(Color.blue.opacity(0.3))
        .cornerRadius(12)
        .padding(4) // Add padding around each card
    }
}

