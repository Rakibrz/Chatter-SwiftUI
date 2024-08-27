//
//  ChatsScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 25-08-2024.
//

import SwiftUI

struct ChatsScreenView: View {
	@EnvironmentObject private var router: PageRouter<AppRoutes>

	@StateObject private var viewModel: ChatViewModel = ChatViewModel()

	var body: some View {
		List(viewModel.chats) { chat in
			VStack(spacing: AppPadding.small) {
				Text(chat.otherUserId)
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .leading)
				Text(chat.date, style: .date)
					.foregroundStyle(Color.theme.lightGrey)
					.frame(maxWidth: .infinity, alignment: .trailing)
			}
			.font(.appFont())
			.onTapGesture {
				router.push(to: .messages(chat: chat))
			}
		}
		.listStyle(.plain)
		.appBar(title: "Chats", tintColor: Color.theme.orange)
		.task {
			viewModel.loadChats()
		}
		.showLoader(when: viewModel.loading)
		.showAlert(message: viewModel.errorMessage, when: $viewModel.showError) {
			Button("OK") { }
		}
	}
}

#Preview {
	ChatsScreenView()
		.applyDefaults()
}
