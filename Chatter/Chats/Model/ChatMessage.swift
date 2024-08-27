//
//  ChatMessage.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Codable, Identifiable, Hashable {
	@DocumentID var id: String?
	var chatId, senderId: String?
	var text: String?
	var date: Date = .now
}

extension ChatMessage {
	var sendByMe: Bool { senderId == FirestoreChatDatabase.user?.uid }
}

struct GrouppedChatMessage: Identifiable, Hashable {
	let id: Date
	var messages: [ChatMessage]
}
