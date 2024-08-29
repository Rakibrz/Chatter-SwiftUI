//
//  ConversionsScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import SwiftUI

struct ConversionsScreenView: View {
	@Environment(\.dismiss) private var dismiss

	@ObservedObject private var viewModel: ConversionViewModel
	@State private var text: String = String()
	@FocusState private var focused: Bool
	
	init(chat: Chat) {
		viewModel = ConversionViewModel(chat: chat)
		viewModel.messages = [ChatMessage(id: UUID().uuidString, text: "This is test message"),
							  ChatMessage(id: UUID().uuidString, text: "This is test message"),
							  ChatMessage(id: UUID().uuidString, text: "This is test message"),
							  ChatMessage(id: UUID().uuidString, text: "This is test message")
		]
	}
	var body: some View {
		ScrollViewReader { proxy in
			List {
				ForEach(viewModel.grouppedMessages) { groupped in
					Section {
						ForEach(groupped.messages) { message in
							TextMessageRowView(message: message)
								.id(message.id)
						}
					} header: {
						Text(groupped.id, style: .date)
							.font(.appFont(size: .medium).weight(.semibold))
							.foregroundStyle(Color.theme.orange)
							.padding()
							.frame(maxWidth: .infinity)
					}
					.id(groupped.id)
				}
				.applySectionRowDefaults(insets: .init(top: .zero, leading: AppPadding.small, bottom: .zero, trailing: AppPadding.small))
			}
			.listStyle(.grouped)
			.applyListDefaults(rowSpacing: AppPadding.small)
			.onChange(of: viewModel.grouppedMessages) { newValue in
				withAnimation {
					proxy.scrollTo(newValue.last?.messages.last?.id, anchor: .bottom)
				}
			}
		}
		.safeAreaInset(edge: .bottom) {
			HStack(spacing: AppPadding.small) {
				TextField(text: $text) {
					Text("Write message here...")
				}
				.focused($focused)
				.font(.appFont().weight(.medium))
				.frame(height: 40)
				.onSubmit {
					sendTextMessage()
				}

				Button(action: {
					sendTextMessage()
				}, label: {
					Image(systemName: "paperplane")
						.imageScale(.large)
						.scaledToFit()
						.foregroundStyle(Color.theme.lightOrange)
						.padding(AppPadding.small)
				})
//				.frame(height: 40)
				.background(Color.theme.orange)
				.clipShape(.circle)
				.hide(when: text.isEmpty)
			}
			.font(.appFont().weight(.medium))
			.padding([.trailing, .vertical], AppPadding.small)
			.padding(.leading)
			.background(Color.theme.lightOrange)
			.clipShape(.capsule)
			.padding()
			.animation(.easeInOut, value: text.isNotEmpty)
		}
		.appNavigationBar(title: "Chat", onLeadingTap: {
			dismiss()
		})
		.onFirstAppear {
			viewModel.loadConversion()
		}
		.showLoader(when: viewModel.loading)
		.showAlert(message: viewModel.errorMessage, when: $viewModel.showError) {
			Button("OK") { }
		}
	}
}

extension ConversionsScreenView {
	func sendTextMessage() {
		guard text.isNotEmpty else { return }
		viewModel.send(text: text)
		withAnimation {
			text = String()
			focused = true
		}
	}
}
#Preview {
	ConversionsScreenView(chat: Chat(id: "JVr7rKEb5I6vSkvJDLJP", createdBy: "", users: []))
		.applyDefaults()
}
