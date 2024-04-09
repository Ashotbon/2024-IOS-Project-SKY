import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var isShowing: Bool
    @Binding var selectedCity: String

    @State private var showingEditView = false
    @State private var showingProfileView = false
    @State private var showingLoginView = false

    var body: some View {
        ZStack {
            if isShowing {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
            }

            VStack(alignment: .leading) {
                HStack {
                    if let user = viewModel.currentUser {
                        Button(user.fullname) {
                            showingProfileView = true
                        }
                        .foregroundColor(.blue)
                    } else {
                        Button("Sign in") {
                            showingLoginView = true
                        }
                        .foregroundColor(.blue)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation {
                            isShowing = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding()

                Divider()

                Text("Locations")
                    .font(.headline)
                    .padding(.leading)

                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.locations, id: \.id) { location in
                            Button(action: {
                                selectedCity = location.name
                                withAnimation {
                                    isShowing = false
                                }
                            }) {
                                Text(location.name)
                                    .padding()
                            }
                        }
                    }

                }
                
                Button("Edit") {
                    showingEditView = true
                }
                .padding([.leading, .top])

                Spacer()
            }
            .frame(width: 375)
            .background(Color.white)
            .offset(x: isShowing ? 0 : -375)
            .transition(.move(edge: .leading))
        }
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

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), selectedCity: .constant(""))
            .environmentObject(AuthViewModel())
    }
}
