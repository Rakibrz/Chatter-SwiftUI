//
//  FirestoreDatabase.swift
//  Chatter
//
//  Created by Rakib Rz  on 24-08-2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FirestoreProtocol {
	var collection: FireStoreCollections { get }
	var database: Firestore { get }
}

class FirestoreUserDatabase: FirestoreProtocol {
	static var user: User? { Auth.auth().currentUser }
	
	static func logout() throws {
		try Auth.auth().signOut()
	}
	
	var collection: FireStoreCollections { .users }
	var database: Firestore = Firestore.firestore()
	
}

extension FirestoreUserDatabase {
	func fetchUsers() async throws -> [UserProfile] {
		var collection = database.collection(collection.rawValue)
		var query = collection.order(by: "name")
		if let userId = FirestoreUserDatabase.user?.uid {
			query = collection.whereField(FieldPath.documentID(), isNotEqualTo: userId).order(by: "name")
		}
		
		let querySnapshot = try await query.getDocuments()
		let response = try querySnapshot.documents.compactMap { snapshot in
			try snapshot.data(as: UserProfile.self)
		}
		return response
	}
}

extension FirestoreUserDatabase {
	func fetchProfile(by userId: String) async throws -> UserProfile {
		let reference = documentReference(user: userId)
		return try await reference.getDocument(as: UserProfile.self)
	}
	
	func update(profile data: UserProfile) async throws {
		let reference = documentReference(user: data.id ?? String())
		try reference.setData(from: data)
//		let auth = Auth.auth()
//		guard let user = auth.currentUser, data.id == user.uid else { return }
//		user.displayName = data.name
//		try await auth.updateCurrentUser(user)
		let request = Auth.auth().currentUser?.createProfileChangeRequest()
		request?.displayName = data.name
		try await request?.commitChanges()
	}
}

private extension FirestoreUserDatabase {
	func documentReference(user documentId: String) -> DocumentReference {
		let collection = Firestore.firestore().collection(collection.rawValue)
		return documentId.isNotEmpty
		? collection.document(documentId)
		: collection.document()
	}
}
