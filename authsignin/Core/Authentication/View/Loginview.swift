//
//  Loginview.swift
//  auth_signin
//
//  Created by Ashot Harutyunyan on 2024-03-22.
//

import SwiftUI

struct Loginview: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                //image
                Image ("SkyLogo" )
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height:120)
                    .padding(.vertical,32)
                //form fields
                VStack(spacing:24) {
                    Inputview(text: $email,
                              title: "Email Address",
                    placeholder: "name@test.com")
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    Inputview(text: $password, title: "Password", placeholder: "Entre your password",
                    isSecureField: true)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
               // signin button
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity( formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top,24)
                
                Spacer()
                
                //signup button
                
                NavigationLink{
                RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack (spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                
            }
        }
    }
}
// Authentication
extension Loginview: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
    
}

#Preview {
    Loginview()
}
//import SwiftUI
//
//// The struct name should be the same as the file name if this is a SwiftUI View
//// Corrected "Loginview" to "LoginView"
//struct LoginView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @EnvironmentObject var viewModel: AuthViewModel // Make sure this environment object is being injected into the view hierarchy
//    
//    var body: some View {
//        NavigationStack { // This is correct for SwiftUI 3 and later
//            VStack {
//                // image
//                Image("SkyLogo") // Ensure "SkyLogo" is the correct name of the asset in your Assets.xcassets
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 120, height: 120)
//                    .padding(.vertical, 32)
//                // form fields
//                VStack(spacing: 24) {
//                    Inputview(text: $email, // Corrected "Inputview" to "InputView" assuming your custom view is named "InputView"
//                              title: "Email Address",
//                              placeholder: "name@test.com")
//                    .autocapitalization(.none) // Removed the template comment and placeholder
//                    
//                    Inputview(text: $password, // Corrected "Inputview" to "InputView"
//                              title: "Password",
//                              placeholder: "Enter your password", // Corrected "Entre" to "Enter"
//                              isSecureField: true)
//                    
//                }
//                .padding(.horizontal)
//                .padding(.top, 12)
//                
//                // sign-in button
//                Button {
//                    Task {
//                        do {
//                            try await viewModel.signIn(withEmail: email, password: password)
//                        } catch {
//                            // Handle errors here, possibly with an alert
//                        }
//                    }
//                } label: {
//                    HStack {
//                        Text("SIGN IN")
//                            .fontWeight(.semibold)
//                        Image(systemName: "arrow.right")
//                    }
//                    .foregroundColor(.white)
//                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
//                }
//                .background(Color(.systemBlue))
//                .disabled(!formIsValid) // Make sure the 'formIsValid' property is accessible
//                .opacity(formIsValid ? 1.0 : 0.5)
//                .cornerRadius(10)
//                .padding(.top, 24)
//                
//                Spacer()
//                
//                // sign-up button
//                
//                NavigationLink {
//                    RegistrationView() // Ensure "RegistrationView" is the correct name of your registration view
//                        .navigationBarBackButtonHidden(true)
//                } label: {
//                    HStack(spacing: 3) {
//                        Text("Don't have an account?")
//                        Text("Sign up")
//                            .fontWeight(.bold)
//                    }
//                    .font(.system(size: 14))
//                }
//                
//            }
//        }
//    }
//}
//
//// Make sure this protocol 'AuthenticationFormProtocol' is defined correctly somewhere in your code
//extension LoginView: AuthenticationFormProtocol {
//    var formIsValid: Bool {
//        return !email.isEmpty
//        && email.contains("@")
//        && !password.isEmpty
//        && password.count >= 6 // Password count greater than or equal to 6 if that's the intended minimum
//    }
//}
//
//// The preview provider should be structured like this:
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView() // Corrected "Loginview" to "LoginView"
//        .environmentObject(AuthViewModel()) // Provided an instance of 'AuthViewModel' to the preview
//    }
//}
