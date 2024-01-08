//
//  ChatViewModel.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import OpenAI

@Observable
class ChatViewModel {
    var chat: AppChat?
    var messages: [AppMessage] = []
    var messageText: String = ""
    var selectedModel: ChatModel = .gpt3_5_turbo
    let chatId: String
    
    var openAIKey: String {
            get {
                access(keyPath: \.openAIKey)
                return UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
            }
            set {
                withMutation(keyPath: \.openAIKey) {
                    UserDefaults.standard.setValue(newValue, forKey: "openai_api_key")
                }
            }
        }
    
    let db = Firestore.firestore()
    
    init(chatId: String) {
        self.chatId = chatId
        print("chatID received= \(chatId)")
        fetchData()
    }
    
    func fetchData() {
        db.collection("chats").document(chatId).getDocument(as: AppChat.self) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.chat = success
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        db.collection("chats").document(chatId).collection("message").getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, !documents.isEmpty else { return }
            
            self.messages = documents.compactMap({ snapshot -> AppMessage? in
                do {
                    var message = try snapshot.data(as: AppMessage.self)
                    message.id = snapshot.documentID
                    return message
                } catch {
                    return nil
                }
            })
        }
    }
    
    func sendMessage() async throws {
        var newMessage = AppMessage(id: UUID().uuidString, text: messageText, role: .user)
        
        do {
            let documentRef = try storeMessage(message: newMessage)
            newMessage.id = documentRef.documentID
        } catch {
            print(error.localizedDescription)
        }
        
        if messages.isEmpty {
            setupNewChat()
        }
        
        await MainActor.run { [newMessage] in
            messages.append(newMessage)
            messageText = ""
        }
        
        try await generateResponse(for: newMessage)
        
    }
    
    private func storeMessage(message: AppMessage) throws -> DocumentReference {
        return try db.collection("chats").document(chatId).collection("message").addDocument(from: message)
    }
    
    private func setupNewChat() {
        db.collection("chats").document(chatId).updateData(["model": selectedModel.rawValue])
        DispatchQueue.main.async { [weak self] in
            self?.chat?.model = self?.selectedModel
        }
    }
    
    private func generateResponse(for message: AppMessage) async throws {
        let openAI = OpenAI(apiToken: "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")
        print("apitoken= \(openAIKey)")
        let queryMessages = messages.map { appMessage in
            Chat(role: appMessage.role, content: appMessage.text)
        }
        let query = ChatQuery(model: chat?.model?.model ?? .gpt3_5Turbo, messages: queryMessages)
        for try await result in openAI.chatsStream(query: query) {
            guard let newText = result.choices.first?.delta.content else { continue }
            await MainActor.run {
                if let lastMessage = messages.last, lastMessage.role != .user {
                    messages[messages.count - 1].text += newText
                } else {
                    let newMessage = AppMessage(id: result.id, text: newText, role: .assistant)
                    messages.append(newMessage)
                }
            }
        }
        
        if let lastMessage = messages.last {
            _ = try storeMessage(message: lastMessage)
        }
    }
}
