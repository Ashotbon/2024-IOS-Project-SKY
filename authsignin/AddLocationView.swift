import SwiftUI
import FirebaseFirestore

struct AddLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel // Use the AuthViewModel
    @Binding var locations: [String]
    @State private var searchText = ""
    @State private var isLoading = false

    let apiKey = "2e0c634311bb50a55aa1e01c3ae5198f"

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Enter the city or zip code")
                    .padding()

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
        }
    }

    func addLocation() async{
        guard !searchText.isEmpty, let userId = viewModel.userSession?.uid else {
            return
        }
        
        let location = Location(id: UUID().uuidString, name: searchText, userId: userId)
        let locationRef = Firestore.firestore().collection("locations").document(location.id)
        
        do {
            try locationRef.setData(from: location)
            locations.append(searchText)
            print("Location added: \(searchText)")
            await viewModel.fetchLocations()
        } catch let error {
            print("Error saving location to Firestore: \(error)")
        }

        presentationMode.wrappedValue.dismiss()
    }
    
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(locations: .constant(["London", "New York"]))
            .environmentObject(AuthViewModel()) // Add this to ensure the preview works
    }
}
