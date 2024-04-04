

import Foundation

struct WeatherResponse: Codable {
    var coord: Coord
    var main: Main
    let name: String
    var weather: [Weather]
    var hourly: [Hourly]?
    

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

    struct Hourly: Codable {
        var dt: TimeInterval
        var temp: Double
    }
}
