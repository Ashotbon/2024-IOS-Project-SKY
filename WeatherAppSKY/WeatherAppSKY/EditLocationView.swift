//
//  EditLocationView.swift
//  WeatherAppSKY
//
//  Created by Ashot Harutyunyan on 2024-03-25.
//


import SwiftUI

struct EditLocationsView: View {
    @Binding var locations: [String]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
                .onDelete(perform: delete)
      
}

struct EditLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        EditLocationsView(locations: .constant(["New York", "Tokyo", "London"]))
    }
}
