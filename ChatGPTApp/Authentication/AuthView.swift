//
//  AuthView.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 26/12/23.
//

import SwiftUI

struct AuthView: View {
    @State var viewModel: AuthViewModel =  AuthViewModel()
    @Environment(AppState.self) private var appState: AppState
    
    var body: some View {
        VStack {
            Text("Chat GPT App")
                .font(.title)
                .bold()
            
            TextField("Email", text: $viewModel.emailText)
                .padding()
                .background(.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if viewModel.isPasswordVisible {
                SecureField("Password", text: $viewModel.passwordText)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .textInputAutocapitalization(.never)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button {
                    viewModel.authenticate(appState: appState)
                } label: {
                    Text(viewModel.userExists ? "Log in": "Create User")
                }
                .padding()
                .foregroundStyle(.white)
                .background(Color.mint)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding()
    }
}

#Preview {
    AuthView()
}
