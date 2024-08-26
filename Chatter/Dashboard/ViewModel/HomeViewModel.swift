//
//  HomeViewModel.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation

class HomeViewModel: ViewModelProtocol {
	
	@Published private(set) var users: [UserProfile] = []
	
	@Published var loading: Bool = false
	@Published var showError: Bool = false
	@Published var errorMessage: String = String() {
		didSet {
			if errorMessage.isNotEmpty {
				print("Error: => \(errorMessage)")
				showError = true
			}
		}
	}
	
	private var firestore = FirestoreUserDatabase()
}

@MainActor
extension HomeViewModel {
	func getUsers() async {
		loading = true
		defer { loading = false }
		do {
			let response = try await firestore.fetchUsers()
			users = response
		} catch {
			errorMessage = error.localizedDescription
		}
	}
}
