//
//  ChatGPTAppApp.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 26/12/23.
//

import SwiftUI

@main
struct ChatGPTAppApp: App {
    
    @State private var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                NavigationStack(path: $appState.navigationPath) {
                    ChatListView()
                }
            } else {
                AuthView()
                    .environment(appState)
            }
            
        }
    }
}
