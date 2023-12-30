//
//  FirestoreDate.swift
//  ChatGPTApp
//
//  Created by Neto Lobo on 29/12/23.
//

import Foundation
import FirebaseFirestore

struct FirestoreDate: Codable, Hashable, Comparable {
    
    var date: Date
    
    init(date: Date = Date()) {
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Timestamp.self)
        date = timestamp.dateValue()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let timestamp = Timestamp(date: date)
        try container.encode(timestamp)
    }
    
    static func < (lhs: FirestoreDate, rhs: FirestoreDate) -> Bool {
        lhs.date < rhs.date
    }
}
