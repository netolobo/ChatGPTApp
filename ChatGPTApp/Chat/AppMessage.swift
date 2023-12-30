//
//  AppMessage.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 28/12/23.
//

import OpenAI
import Foundation
import FirebaseFirestoreSwift

struct AppMessage: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var text: String
    let role: Chat.Role
    var createdAt: FirestoreDate = FirestoreDate()
}
