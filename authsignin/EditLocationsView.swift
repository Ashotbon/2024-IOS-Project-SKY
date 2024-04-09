import SwiftUI

struct EditLocationsView: View {
    @Binding var locations: [String]
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
                    List {
                        ForEach(viewModel.locations.map { $0.name }, id: \.self) { location in
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
          let namesToDelete = offsets.compactMap { viewModel.locations.map { $0.name }[$0] }
          namesToDelete.forEach { name in
              Task {
                  await viewModel.deleteLocation(named: name)
              }
          }
      }
    
}

struct EditLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        EditLocationsView(locations: .constant(["New York", "Tokyo", "London"]))
            .environmentObject(AuthViewModel()) // Make sure to provide an environment object in previews
    }
}
