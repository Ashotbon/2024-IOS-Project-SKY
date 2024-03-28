


import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var isShowing: Bool
    @Binding var locations: [String]
    @State private var showingEditView = false
    @State private var showingProfileView = false
    @State private var showingLoginView = false
    @Environment(\.dismiss) var dismiss

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
                Button(action: {
                                  dismiss()  // the dismiss action to close the view
                              })  {
                                  Image(systemName: "arrow.left")
                                      .foregroundColor(.black)
                                      .imageScale(.large)
                        
                              }
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
            .offset(x: isShowing ? 0 : -375)
            .transition(.move(edge: .leading))

            // Sign In or Profile View
            .fullScreenCover(isPresented: $showingLoginView) {
                Loginview()
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $showingProfileView) {
                Profileview()
                    .environmentObject(viewModel)
            }

            // Edit Locations View
            .sheet(isPresented: $showingEditView) {
                EditLocationsView(locations: $locations)
            }
        }
    }
}

