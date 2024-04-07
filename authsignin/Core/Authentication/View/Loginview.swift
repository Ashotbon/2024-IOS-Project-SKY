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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        Button("Cancel") {
                            dismiss()  // Dismiss the view
                        }
                        .foregroundColor(.blue)
                        .padding()

                        Spacer()
                    }
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
