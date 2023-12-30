//
//  ProfileView.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import SwiftUI

struct ProfileView: View {
    @State var apiKey: String = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    var body: some View {
        List {
            Section("OpenAI API Key") {
                TextField("Enter key", text: $apiKey) {
                    UserDefaults.standard.set(apiKey, forKey: "openai_api_key")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
