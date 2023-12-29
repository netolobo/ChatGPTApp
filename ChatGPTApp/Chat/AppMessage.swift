//
//  AppMessage.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 28/12/23.
//

import OpenAI
import Foundation

struct AppMessage: Identifiable, Codable, Hashable {
    let id: String?
    var text: String
    let role: Chat.Role
    let createdAt: Date
}
