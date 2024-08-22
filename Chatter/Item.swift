//
//  Item.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
