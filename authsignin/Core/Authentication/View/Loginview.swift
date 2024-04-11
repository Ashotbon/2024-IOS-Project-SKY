import SwiftUI

struct Loginview: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showResetPasswordPopup = false
    @State private var resetEmail = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .padding()

                    Spacer()
                }
                
                Image("SkyLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .padding(.vertical, 32)

                VStack(spacing: 24) {
                    Inputview(text: $email, title: "Email Address", placeholder: "name@test.com")
                        .autocapitalization(.none)
                    
                    Inputview(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Button("SIGN IN") {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.top, 24)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1 : 0.5)

                Button("Forgot Password?") {
                    showResetPasswordPopup = true
                }
                .padding()

                Spacer()

                NavigationLink("Don't have an account? Sign up", destination: RegistrationView())
                    .font(.system(size: 14))
            }
            .sheet(isPresented: $showResetPasswordPopup) {
                ResetPasswordView(email: $resetEmail, showResetPasswordPopup: $showResetPasswordPopup)
            }
        }
    }

    var formIsValid: Bool {
        !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}



struct Loginview_Previews: PreviewProvider {
    static var previews: some View {
        Loginview()
            .environmentObject(AuthViewModel())
    }
}
