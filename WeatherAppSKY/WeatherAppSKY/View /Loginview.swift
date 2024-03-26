//
//  Loginview.swift
//  WeatherAppSKY
//
//  Created by Ashot Harutyunyan on 2024-03-26.
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
                
