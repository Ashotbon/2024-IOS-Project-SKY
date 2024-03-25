//
//  SideMenuView.swift
//  WeatherAppSKY
//
//  Created by Ashot Harutyunyan on 2024-03-25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var locations: [String]
    @State private var showingEditView = false
    @State private var showingSignInView = false

    var body: some View {
        ZStack {
            // Background dimming
            if isShowing {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
            }

            // Side menu content
            VStack(alignment: .leading) {
                // User account or other top content
                Button("Sign in") {
                    withAnimation {
                        showingSignInView = true
                    }
                }
                .foregroundColor(.blue)
                .padding()

                Divider()

                // Locations list
                VStack(alignment: .leading) {
                    Text("Locations")
                        .font(.headline)
                        .padding(.leading)

                    ForEach(locations, id: \.self) { location in
                        Text(location)
                            .padding()
                    }

                    Button("Edit") {
                        showingEditView = true
                    }
                    .padding([.leading, .top])
                }

                Spacer()
            }
            .frame(width: 375)
            .background(Color.white)
            .offset(x: isShowing ? 0 : -250)
            .transition(.move(edge: .leading))
            .animation(.easeInOut(duration: 0.3), value: isShowing)

            }
        }
    }


struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), locations: .constant(["New York", "Tokyo", "London"]))
    }
}
