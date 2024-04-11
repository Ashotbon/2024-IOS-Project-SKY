//
//  ResetPasswordView.swift
//  2024-IOS-Project-SKY
//
//  Created by Ashot Harutyunyan on 2024-04-10.
//

import Foundation
import SwiftUI

struct ResetPasswordView: View {
    @Binding var email: String
    @Binding var showResetPasswordPopup: Bool
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.headline)
                .padding()

            TextField("Enter your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Send Reset Link") {
                Task {
                    await viewModel.forgetPassword(withEmail:email)
                    showResetPasswordPopup = false
                }
            }
            .disabled(!isValidEmail(email))
            .padding()

            Button("Cancel") {
                showResetPasswordPopup = false
            }
            .padding()
        }
        .padding()
    }

    func isValidEmail(_ email: String) -> Bool {
        // Add your email validation logic here
        return email.contains("@") && email.contains(".")
    }
}

//struct ResetPasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        showResetPasswordPopup();
//    }
//}
