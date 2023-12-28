//
//  AppState.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import Firebase
import FirebaseAuth
import Foundation
import Swift

@Observable
class AppState {
    var currentUser: User?
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    init() {
        FirebaseApp.configure()
        
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
