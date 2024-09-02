//
//  ConversionViewModel.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import Foundation

class ConversionViewModel: ViewModelProtocol {
	
	@Published var messages: [ChatMessage] = []
	@Published var grouppedMessages: [GrouppedChatMessage] = []
	
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
	
	private let manager: FirestoreMessagesDatabase
	
	init(chat: Chat) {
		manager = FirestoreMessagesDatabase(chat: chat)
	}
	
}

@MainActor
extension ConversionViewModel {
	
	func send(text: String) {
		Task {
			do {
//				let date = Calendar.appCalendar.date(byAdding: .day, value: -1, to: .now) ?? .now
				let newMessage = ChatMessage(chatId: manager.chat.id, senderId: FirestoreMessagesDatabase.user?.uid, text: text)
				let response = try await manager.send(message: newMessage)
				messages.append(response)
			} catch {
				errorMessage = error.localizedDescription
			}
		}
	}
	func loadConversion(last: ChatMessage?) {
		loading = true
		defer { loading = false }
		
		manager.fetchMessages(start: last) { [weak self] result in
			switch result {
			case .success(let dataList):
				let dictionary = Dictionary(grouping: dataList) { item -> Date in
					let dateComps = Calendar.appCalendar.dateComponents([.day, .month, .year], from: item.date)
					let date = Calendar.appCalendar.date(from: dateComps) ?? .now
					return date
				}
				DispatchQueue.main.async {
					dictionary.forEach { (key: Date, values: [ChatMessage]) in
						if let index = self?.grouppedMessages.firstIndex(where: { $0.id.isSameDate(as: key) }) {
							values.forEach { message in
								if let messageIndex = self?.grouppedMessages[index].messages.firstIndex(where: { $0.id == message.id }) {
									self?.grouppedMessages[index].messages[messageIndex] = message
								} else {
									self?.grouppedMessages[index].messages.append(message)
								}
							}
						} else {
							self?.grouppedMessages.append(.init(id: key, messages: values))
							self?.grouppedMessages.sort(by: { $0.id < $1.id })
						}
					}
				}
			case .failure(let error):
				self?.errorMessage = error.localizedDescription
			}
		}
	}
}
