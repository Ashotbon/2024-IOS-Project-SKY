//
//  SideMenuView.swift
//  WeatherAppSKY
//
//  Created by Ashot Harutyunyan on 2024-03-25.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var isShowing: Bool
    @Binding var locations: [String]
    @State private var showingEditView = false
        @State private var showingProfileView = false
        @State private var showingLoginView = false

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
                if let user = viewModel.currentUser {
                    // User is signed in, show user's name and profile button
                    Button(user.fullname) {
                        showingProfileView = true
                    }
                    .foregroundColor(.blue)
                    .padding()
                } else {
                    // User is not signed in, show Sign in button
                    Button("Sign in") {
                        showingLoginView = true
                    }
                    .foregroundColor(.blue)
                    .padding()
                }

                
//                Button("Sign in") {
//                    if viewModel.userSession != nil {
//                        showingProfileView = true
//                    } else {
//                        showingLoginView = true
//                    }
//                }
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
            .offset(x: isShowing ? 0 : -375) // Adjust the offset value as needed
            .transition(.move(edge: .leading))

            // Sign In or Profile View
            .fullScreenCover(isPresented: $showingLoginView) {
                Loginview()
                    .environmentObject(viewModel) // Pass the viewModel to maintain state
            }
            .fullScreenCover(isPresented: $showingProfileView) {
                Profileview()
                    .environmentObject(viewModel) // Pass the viewModel to maintain state
            }

            // Edit Locations View
            .sheet(isPresented: $showingEditView) {
                EditLocationsView(locations: $locations)
            }
        }
    }
}
