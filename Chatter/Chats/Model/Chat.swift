//
//  Chat.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation
import FirebaseFirestore

struct Chat: Codable, Identifiable, Hashable {
	@DocumentID var id: String?

	var createdBy: String
	var users: [String]
	var date: Date = .now
}

extension Chat {
	var otherUserId: String {
		return users.first(where: { $0 != FirestoreUserDatabase.user?.uid }) ?? String()
	}
}
