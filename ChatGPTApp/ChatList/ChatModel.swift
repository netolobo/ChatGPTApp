//
//  ChatModel.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 27/12/23.
//

import Foundation
import SwiftUI

enum ChatModel: String, Codable, CaseIterable, Hashable {
    case gpt3_5_turbo = "GPT 3.5 Turbo"
    case gpt4 = "GPT 4"
    
    var tintColor: Color {
        switch self {
        case .gpt3_5_turbo:
            return .green
        case .gpt4:
            return .purple
        }
    }
}
