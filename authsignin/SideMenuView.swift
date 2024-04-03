


import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var isShowing: Bool

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
                    Button(user.fullname) {
                        showingProfileView = true
                    }
                    .foregroundColor(.blue)
                    .padding()
                } else {
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

                    ForEach(viewModel.locations, id: \.id) { location in
                        Text(location.name)
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

            .fullScreenCover(isPresented: $showingLoginView) {
                Loginview()
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $showingProfileView) {
                Profileview()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showingEditView) {
                EditLocationsView(locations: .constant(viewModel.locations.map { $0.name }))
            }
        }
    }
}


import SwiftUI
