//
//  ChatListView.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import Foundation

@Observable
class ChatListViewModel {
    var chats: [AppChat] = []
    var loadingState: ChatListState = .none
    var isShowingProfileView = false
    
    func fetchData() {
        self.chats = [
            AppChat(id: "1", topic: "Some topic", model: .gpt3_5_turbo, lastMessageSent: Date(), owner: "123"),
            AppChat(id: "2", topic: "Some other topic", model: .gpt4, lastMessageSent: Date(), owner: "123")
        ]
        self.loadingState = .resultsFound
    }
    
    func createChat() {
        
    }
    
    func showProfile() {
        isShowingProfileView = true
    }
    
    func deleteChat(_ chat: AppChat) {
        
    }
}
