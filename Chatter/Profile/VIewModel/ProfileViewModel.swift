//
//  ProfileViewModel.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI


class ProfileViewModel: ViewModelProtocol {
	
	@AppStorage(StorageKey.appState.title) static private var appState: AppState?

	@Published var user: UserProfile = UserProfile(id: FirestoreUserDatabase.user?.uid ?? String(), phoneNumber: FirestoreUserDatabase.user?.phoneNumber ?? String(), name: FirestoreUserDatabase.user?.displayName ?? String())
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

	@Published var showSuccess: Bool = false
	let profileUpdateMessage: String = String("Profile has been updated successfully.")

	private var firestore = FirestoreUserDatabase()
}

@MainActor
extension ProfileViewModel {
	
	@discardableResult
	func getProfile() async -> UserProfile {
		defer { loading = false }
		loading = true
		do {
			if let userId = user.id, userId.isNotEmpty {
				let response = try await firestore.fetchProfile(by: userId)
				user = response
			}
		} catch {
			errorMessage = error.localizedDescription
		}
		return user
	}

	func updateProfile() async {
		guard user.name.isNotEmpty else {
			errorMessage = "Name should not be empty."
			return
		}
		
		defer { loading = false }
		loading = true
		do {
			try await firestore.update(profile: user)
			showSuccess = true
		} catch {
			errorMessage = error.localizedDescription
		}
	}
	
	@discardableResult
	static func logout() -> Bool {
		do {
			try FirestoreUserDatabase.logout()
			appState = .logout
			return true
		} catch {
			print("\(#function) error: \(error.localizedDescription)")
		}
		return false
	}
}
