import SwiftUI
import FirebaseFirestore

struct AddLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var locations: [String]

    @State private var searchText = ""
    @State private var isLoading = false
    @State private var showingLocationError = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Enter the city or zip code")
                    .padding()

                if showingLocationError {
                    Text("Location not found. Please try again.")
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Add Location") {
                    print("Adding location for city: \(searchText)")
                    Task {
                        await addLocation()
                    }
                }
                .padding()
                .disabled(searchText.isEmpty)

                Spacer()
            }
            .navigationBarTitle("Add a new location", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            searchText = ""
            showingLocationError = false
        }
    }

    func addLocation() async {
        guard !searchText.isEmpty, let userId = viewModel.userSession?.uid else {
            return
        }

        let formattedCity = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "\(K.baseURL)weather?q=\(formattedCity)&appid=\(K.apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL for city \(searchText)")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let _ = try JSONDecoder().decode(WeatherResponse.self, from: data)

            let location = Location(id: UUID().uuidString, name: searchText, userId: userId)
            let locationRef = Firestore.firestore().collection("locations").document(location.id)

            try locationRef.setData(from: location)
            locations.append(searchText)
            await viewModel.fetchLocations()

            presentationMode.wrappedValue.dismiss()
            showingLocationError = false
        } catch {
            print("Error fetching city data or saving location: \(error)")
            showingLocationError = true
        }
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(locations: .constant(["London", "New York"]))
            .environmentObject(AuthViewModel())
    }
}
