//
//  Constants.swift
//  2024-IOS-Project-SKY
//
//  Created by Ashot Harutyunyan on 2024-04-07.
//


import Foundation

struct K {
    static let apiKey = "2e0c634311bb50a55aa1e01c3ae5198f"
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    struct Firestore {
        static let locationsCollection = "locations"
        static let usersCollection = "users"
    }
    
    struct UI {
        static let defaultPadding: CGFloat = 16.0
        static let cornerRadius: CGFloat = 5.0
    }
    
    struct Notifications {
        static let userDidLogIn = "UserDidLogInNotification"
    }
}
