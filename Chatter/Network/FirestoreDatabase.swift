//
//  FirestoreDatabase.swift
//  Chatter
//
//  Created by Rakib Rz  on 24-08-2024.
//

import FirebaseFirestore
import FirebaseAuth

protocol FirestoreProtocol {
	static var user: User? { get }
	var collection: FireStoreCollections { get }
	var database: Firestore { get }
	
}

extension FirestoreProtocol {
	static var user: User? { Auth.auth().currentUser }

	var database: Firestore { Firestore.firestore() }
	var collectionRef: CollectionReference { database.collection(collection.rawValue) }
}

class FirestoreUserDatabase: FirestoreProtocol {
	
	static func logout() throws {
		try Auth.auth().signOut()
	}
	
	var collection: FireStoreCollections { .users }
}

// MARK: - All Users functions
extension FirestoreUserDatabase {
	func fetchUsers() async throws -> [UserProfile] {
		var query = collectionRef.order(by: "name")
		if let userId = FirestoreUserDatabase.user?.uid {
			query = collectionRef.whereField(FieldPath.documentID(), isNotEqualTo: userId).order(by: "name")
		}
		
		let querySnapshot = try await query.getDocuments()
		let response = try querySnapshot.documents.compactMap { snapshot in
			try snapshot.data(as: UserProfile.self)
		}
		return response
	}
}

// MARK: - Specific User's functions
extension FirestoreUserDatabase {
	func fetchProfile(by userId: String) async throws -> UserProfile {
		let reference = documentReference(user: userId)
		return try await reference.getDocument(as: UserProfile.self)
	}
	
	func update(profile data: UserProfile) async throws {
		let reference = documentReference(user: data.id ?? String())
		try reference.setData(from: data)
		guard data.id == Self.user?.uid else { return }
		let request = Self.user?.createProfileChangeRequest()
		request?.displayName = data.name
		try await request?.commitChanges()
	}
}

private extension FirestoreUserDatabase {
	func documentReference(user documentId: String) -> DocumentReference {
		documentId.isNotEmpty
		? collectionRef.document(documentId)
		: collectionRef.document()
	}
}
