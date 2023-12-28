//
//  AuthViewModel.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 26/12/23.
//

import Foundation

@Observable
class AuthViewModel {
    var emailText: String = ""
    var passwordText: String = ""
    
    var isLoading = false
    var isPasswordVisible = false
    var userExists = false
    
    let authService = AuthService()
    
    func authenticate(appState: AppState) {
        isLoading = true
        
        Task {
            do {
                if isPasswordVisible {
                    let result = try await authService.login(email: emailText, password: passwordText, userExisits: userExists)
                    guard let result = result else { return }
                    appState.currentUser = result.user
                } else {
                    userExists = try await authService.checkUserExists(email: emailText)
                    isPasswordVisible = true
                }
                isLoading = false
            } catch {
                print(error)
                isLoading = false
            }
        }
    }
}
