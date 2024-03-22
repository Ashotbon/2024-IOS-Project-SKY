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
