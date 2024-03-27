//
//  ContentView.swift
//  auth_signin
//
//  Created by Ashot Harutyunyan on 2024-03-22.
//

import SwiftUI

struct ContentView1: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                Profileview()
            } else {
                Loginview()
            }
            
        }
       
    }
}

#Preview {
    ContentView()
}
