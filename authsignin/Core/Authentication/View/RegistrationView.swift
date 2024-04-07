//
//  RegistrationView.swift
//  auth_signin
//
//  Created by Ashot Harutyunyan on 2024-03-22.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                    }
                    Spacer() 
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer().frame(height: 20)
            Image("SkyLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .padding(.vertical, 32)

            VStack(spacing: 24) {
                Inputview(text: $email,
                          title: "Email Address",
                          placeholder: "name@test.com")
                .autocapitalization(.none)
                
                Inputview(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")
              
                Inputview(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack(alignment: .trailing) {
                    Inputview(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(password == confirmPassword ? Color(.systemGreen) : Color(.systemRed))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button(action: {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                }
            }) {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(Color(.systemBlue))
                .cornerRadius(10)
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1 : 0.5)
            .padding(.top, 24)
            
            Spacer()
        }
    }
}

// Authentication form validation logic
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count > 5 &&
        password == confirmPassword &&
        !fullname.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
