//
//  ChatsViewModel.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation


class ChatViewModel: ViewModelProtocol {
	@Published var chats: [Chat] = []
	
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
	
	private lazy var manager: FirestoreChatDatabase = FirestoreChatDatabase()
}

@MainActor
extension ChatViewModel {
	func createChat(with profile: UserProfile) async -> Chat? {
		loading = true
		defer { loading = false }
		do {
			let chat = try await manager.createChat(with: profile.id ?? String())
			return chat
		} catch {
			errorMessage = error.localizedDescription
		}
		
		return .none
	}
	
	func loadChats() {
		Task {
			loading = true
			defer { loading = false }
			do {
				let response = try await manager.fetchChats()
				chats = response
			} catch {
				errorMessage = error.localizedDescription
			}
		}
	}
}
