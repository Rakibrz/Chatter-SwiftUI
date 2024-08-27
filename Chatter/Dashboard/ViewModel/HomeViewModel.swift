//
//  HomeViewModel.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation

class HomeViewModel: ViewModelProtocol {
	
	@Published private(set) var users: [UserProfile] = []
	
	// Common variables
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
	
	private lazy var manager: FirestoreUserDatabase = FirestoreUserDatabase()
}

@MainActor
extension HomeViewModel {
	func getUsers() async {
		loading = true
		defer { loading = false }
		do {
			let response = try await manager.fetchUsers()
			users = response
		} catch {
			errorMessage = error.localizedDescription
		}
	}
}
