//
//  FirestoreMessagesDatabase.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation
import FirebaseFirestore

class FirestoreMessagesDatabase: FirestoreProtocol {
	var collection: FireStoreCollections { .messages }
	
	@Published var chat: Chat
	var messageListner: ListenerRegistration?
	
	private var collectionRef: CollectionReference {
		database.collection(FireStoreCollections.chats.rawValue).document(chat.id!).collection(collection.rawValue)
	}
	
	init(chat: Chat) {
		self.chat = chat
	}
	
	deinit {
		print("\(Self.self) Deinit Called")
		deleteListner()
	}
}

extension FirestoreMessagesDatabase {
	func fetchMessages(start from: ChatMessage?, completion handler: @escaping ValueCallback<Result<[ChatMessage], Error>>) {
		var reference = collectionRef.order(by: "date", descending: false)
		
		if let lastDate = from?.date {
			reference = reference.start(after: [lastDate])
		}
//		reference = reference.limit(to: 10)
		
		messageListner = reference.addSnapshotListener(includeMetadataChanges: true) { snapshots, error in
			do {
				let response: [ChatMessage] = try snapshots?.documentChanges.compactMap({ docDiff in
					if docDiff.type == .added || docDiff.type == .modified {
						return try docDiff.document.data(as: ChatMessage.self)
					}
					return nil
				}) ?? []
				handler(.success(response))
			} catch {
				handler(.failure(error))
			}
		}
	}

	func send(message: ChatMessage) async throws -> ChatMessage {
		let reference = collectionRef.document()
		try reference.setData(from: message)
		var message = message
		message.id = reference.documentID
		return message
	}
}

private extension FirestoreMessagesDatabase {
	func deleteListner() {
		print("\(#function) Called")
		messageListner?.remove()
	}

}
