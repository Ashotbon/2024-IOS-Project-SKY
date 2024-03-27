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
            //image
            Image ("SkyLogo" )
                .resizable()
                .scaledToFill()
                .frame(width: 120, height:120)
                .padding(.vertical,32)
            
            VStack(spacing:24) {
                Inputview(text: $email,
                          title: "Email Address",
                placeholder: "name@test.com")
                .autocapitalization(.none)
                
                Inputview(text: $fullname,
                          title: "Full Name",
                placeholder: "Enter your name")
              
                
                Inputview(text: $password, title: "Password", placeholder: "Entre your password",
                isSecureField: true)
                
                ZStack(alignment: .trailing){
                    Inputview(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password",
                    isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty{
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email,
                                                   password:password,
                                                   fullname:fullname)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
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
            
            Button {
                dismiss()
            } label: {
                HStack (spacing: 3){
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
}
// Authentication
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
    
}
#Preview {
    RegistrationView()
}
