//
//  SearchBar.swift
//  WeatherApp
//
//  Created by Ashot Harutyunyan on 2024-03-18.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

//    func makeUIView(context: Context) -> UISearchBar {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = placeholder
//        return searchBar
//    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.delegate = context.coordinator  // Set the delegate to the coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar

        init(_ searchBar: SearchBar) {
            self.parent = searchBar
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
}
