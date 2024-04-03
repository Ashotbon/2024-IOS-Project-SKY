//
//  Location.swift
//  2024-IOS-Project-SKY
//
//  Created by Ashot Harutyunyan on 2024-04-01.
//

import Foundation

struct Location: Codable, Identifiable {
    var id: String
    var name: String
    var userId: String // Associate each location with a user
}
