//
//  ChatListView.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable
class ChatListViewModel {
    var chats: [AppChat] = []
    var loadingState: ChatListState = .none
    var isShowingProfileView = false
    
    private let db = Firestore.firestore()
    
    func fetchData(user: String?) {
        
        if loadingState == .none {
            loadingState = .loading
            db.collection("chats").whereField("owner", isEqualTo: user ?? "").addSnapshotListener { [weak self]querySnaphot, error in
                guard let self = self, let documents = querySnaphot?.documents, !documents.isEmpty else {
                    self?.loadingState = .noResults
                    return
                }
                
                self.chats = documents.compactMap({ snapshot -> AppChat? in
                    return try? snapshot.data(as: AppChat.self)
                })
                .sorted(by: {$0.lastMessageSent > $1.lastMessageSent})
                self.loadingState = .resultsFound
            }
        }
    }
    
    func createChat(user: String?) async throws -> String {
        let document = try await db.collection("chats").addDocument(data: ["lastMessageSent": Date(), "owner": user ?? ""])
        return document.documentID
    }
    
    func showProfile() {
        isShowingProfileView = true
    }
    
    func deleteChat(_ chat: AppChat) {
        guard let id = chat.id else { return }
        db.collection("chats").document(id).delete()
    }
}
