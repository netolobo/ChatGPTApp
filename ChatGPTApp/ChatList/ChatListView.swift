//
//  ChatListView.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import SwiftUI

struct ChatListView: View {
    @State private var viewModel = ChatListViewModel()
    @Environment(AppState.self) private var appState
    
    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .loading, .none:
                Text("Loading chats...")
            case .noResults:
                Text("No chats.")
            case .resultsFound:
                List {
                    ForEach(viewModel.chats) { chat in
                        NavigationLink(value: chat.id) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(chat.topic ?? "New chat")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(chat.model?.rawValue ?? "")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(chat.model?.tintColor ?? .white).opacity(0.9)
                                        .padding(6)
                                        .clipShape(Capsule(style: .continuous))
                                    
                                }
                                Text(chat.lastMessageTimeAgo)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteChat(chat)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showProfile()
                } label: {
                    Image(systemName: "person")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        do {
                            let chatID = try await viewModel.createChat(user: appState.currentUser?.uid)
                            appState.navigationPath.append(chatID)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingProfileView) {
            ProfileView()
        }
        .navigationDestination(for: String.self) { chatId in
            ChatView(viewModel: .init(chatId: chatId))
        }
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.fetchData(user: appState.currentUser?.uid)
            }
        }
    }
}

#Preview {
    ChatListView()
}
