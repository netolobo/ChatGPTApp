//
//  ChatViewModel.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import Foundation

@Observable
class ChatViewModel {
    var chat: AppChat?
    var messages: [AppMessage] = []
    var messageText: String = ""
    var selectedModel: ChatModel = .gpt3_5_turbo
    let chatId: String
    
    init(chatId: String) {
        self.chatId = chatId
    }
    
    func fetchData() {
        self.messages = [
            AppMessage(id: "1", text: "Hello how are your", role: .user, createdAt: Date()),
            AppMessage(id: "2", text: "Im good Thanks", role: .assistant, createdAt: Date()),
        ]
    }
    
    func sendMessage() {
        var newMessage = AppMessage(id: UUID().uuidString, text: messageText, role: .user, createdAt: Date())
        messages.append(newMessage)
        messageText = ""
    }
}
