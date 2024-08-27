//
//  FirestoreChatDatabase.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation

class FirestoreChatDatabase: FirestoreProtocol {
	var collection: FireStoreCollections { .chats }
}

extension FirestoreChatDatabase {
	func createChat(with userId: String) async throws -> Chat {
		let currentUserId: String = Self.user?.uid ?? String()
		
		let query = try await collectionRef.whereField("users", arrayContainsAny: [currentUserId, userId]).limit(to: 1).getDocuments()
		if query.documents.isEmpty == false {
			let chat = try query.documents[0].data(as: Chat.self)
			return chat
		}
		
		var newChat = Chat(createdBy: currentUserId, users: [currentUserId, userId])
		let reference = collectionRef.document()
		newChat.id = reference.documentID
		try reference.setData(from: newChat)
		return newChat
	}
	
	func fetchChats() async throws -> [Chat] {
		guard let userId = Self.user?.uid else {
			throw NSError(domain: "SESSION_EXPIRED", code: 404, userInfo: [NSLocalizedDescriptionKey : "Please logout and login again!"])
		}
		let query = collectionRef.whereField("users", arrayContains: userId).order(by: "date", descending: false)
		let querySnapshot = try await query.getDocuments()
		let response = try querySnapshot.documents.compactMap({ try $0.data(as: Chat.self) })
		return response
	}
}
