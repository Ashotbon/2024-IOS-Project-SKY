//
//  EditLocationsView.swift
//  WeatherApp
//
//  Created by Ashot Harutyunyan on 2024-03-17.
//

//import SwiftUI
//
//struct EditLocationsView: View {
//    @Binding var locations: [String]
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(locations, id: \.self) { location in
//                    Text(location)
//                }
//                .onDelete(perform: delete)
//            }
//            .navigationBarTitle("Edit locations", displayMode: .inline)
//            .navigationBarItems(leading: Button("Done") {
//                presentationMode.wrappedValue.dismiss()
//            })
//            .toolbar {
//                EditButton()
//            }
//        }
//    }
//    
//    func delete(at offsets: IndexSet) {
//        locations.remove(atOffsets: offsets)
//    }
//}
//
//struct EditLocationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditLocationsView(locations: .constant(["New York, NY", "Paris", "Montreal, QC"]))
//    }
//}


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
            .navigationBarTitle("Edit Locations")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        locations.remove(atOffsets: offsets)
    }
}

struct EditLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        EditLocationsView(locations: .constant(["New York", "Tokyo", "London"]))
    }
}
