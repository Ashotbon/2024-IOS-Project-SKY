//
//  AuthViewModel.swift
//  auth_signin
//
//  Created by Ashot Harutyunyan on 2024-03-24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol{
    var formIsValid: Bool { get }
    
}
                                        
@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var locations: [Location] = []

    init() {
        self.userSession = Auth.auth().currentUser

        Task {
            await fetchUser()
        }
        
    }
    
    func fetchLocations() async {
        guard let uid = userSession?.uid else { return }

        let query = Firestore.firestore().collection("locations").whereField("userId", isEqualTo: uid)
        let snapshot = try? await query.getDocuments()
        self.locations = snapshot?.documents.compactMap { try? $0.data(as: Location.self) } ?? []
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            await fetchLocations()
            print("DEBUG: Locations after signing in:", self.locations)
        } catch {
            print ("DEBUG: Faild to log in with error \(error.localizedDescription)")
            
        }
    }

    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
//            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            
            let usersRef = Firestore.firestore().collection("users").document(user.id)
                    try await usersRef.setData(encodedUser)

                    // Optionally initialize locations for the user
                    let initialLocation = Location(id: UUID().uuidString, name: "Default Location", userId: user.id)
                    let encodedLocation = try Firestore.Encoder().encode(initialLocation)
                    
                    // Save initial location data to Firestore
                    let locationsRef = Firestore.firestore().collection("locations").document(initialLocation.id)
                    try await locationsRef.setData(encodedLocation)
            
            await fetchUser()
            await fetchLocations()  // Fetch locations for the new user
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()// signs out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil // wipes out current user data model
            locations = []
        }catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }

    func deleteAccount() {

    }

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)

    }
    
    func forgetPassword(withEmail email: String) async {
          do {
              try await Auth.auth().sendPasswordReset(withEmail: email)
              // Optionally, handle any user feedback or navigation here
              print("Password reset email sent.")
          } catch {
              print("Error sending password reset email: \(error.localizedDescription)")
          }
      }
    
    func deleteLocation(named name: String) async {
        guard let userId = userSession?.uid else { return }

        let query = Firestore.firestore().collection("locations")
            .whereField("name", isEqualTo: name)
            .whereField("userId", isEqualTo: userId)

        let snapshot = try? await query.getDocuments()
        guard let documents = snapshot?.documents else {
            print("No documents found for deletion")
            return
        }

        for document in documents {
                  do {
                      try await document.reference.delete()
                      print("Document successfully removed!")
                  } catch {
                      print("Error deleting document: \(error)")
                  }
              }
              
              await fetchLocations()
    }

}
