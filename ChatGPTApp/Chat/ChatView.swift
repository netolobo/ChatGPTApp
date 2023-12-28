//
//  ChatView.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import SwiftUI

struct ChatView: View {
    var viewModel : ChatViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel(chatId: ""))
}
