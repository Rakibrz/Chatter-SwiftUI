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
//	@State private var text: String = String("5dkfn sdfj sjfosdpfjpgj3po wjef pojf[psj posdfjioghs sv e gpoergo ejrps fjpsj vpofgjer oghjsp ofjspvj spofgj erpgj spddsj dfpodjgperjsfpsv jdpbojepo sfjpsf  pfjspd fjpsodfj svsdf")
	
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
				ForEach(viewModel.grouppedMessages.reversed()) { groupped in
					Section {
						ForEach(groupped.messages) { message in
							TextMessageRowView(message: message)
								.id(message.id)
								.onFirstAppear {
									print("Date: \(message.date.formatted())")
								}
						}
						.transition(.move(edge: .bottom))
						//						.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
					} header: {
						Text(groupped.id, style: .date)
							.font(.appFont(size: .medium).weight(.semibold))
							.foregroundStyle(Color.theme.orange)
							.padding()
							.frame(maxWidth: .infinity)
						//							.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
							.scaleEffect(x: 1, y: -1)
					}
					.id(groupped.id)

//					.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
				}
				.applySectionRowDefaults(insets: .init(top: .zero, leading: AppPadding.small, bottom: .zero, trailing: AppPadding.small))
//				.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
			}
			.listStyle(.grouped)
			.applyListDefaults(rowSpacing: AppPadding.small)
			.scaleEffect(x: 1, y: -1)

//			.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
			.onChange(of: viewModel.grouppedMessages) { newValue in
				withAnimation {
					proxy.scrollTo(newValue.last?.messages.last?.id, anchor: .bottom)
				}
			}
		}
		.safeAreaInset(edge: .bottom) {
			HStack(spacing: AppPadding.small) {
				TextField(text: $text, axis: .vertical) {
					Text("Write message here...")
//						.font(.appFont().weight(.thin))
				}
				.focused($focused)
				.font(.appFont())
				.lineLimit(5)
				.padding(.vertical, AppPadding.small)
				.onSubmit {
					sendTextMessage()
				}

				Button(action: {
					sendTextMessage()
				}, label: {
					Image(systemName: "paperplane")
						.imageScale(.large)
						.scaledToFit()
						.rotationEffect(.degrees(45))
				})
				.foregroundStyle(Color.theme.orange.opacity(text.isEmpty ?  0.3 : 1.0))
				.disabled(text.isEmpty)
			}
			.font(.appFont().weight(.medium))
			.padding(.horizontal)
			.background(Color.theme.lightOrange)
			.clipShape(.rect(cornerRadius:18))
			.padding()
			.animation(.easeInOut, value: text.isNotEmpty)
		}
		.appNavigationBar(title: "Chat", onLeadingTap: {
			dismiss()
		})
		.onFirstAppear {
			viewModel.loadConversion(last: .none)
		}
		.showLoader(when: viewModel.loading)
		.showAlert(message: viewModel.errorMessage, when: $viewModel.showError) {
			Button("OK") { }
		}
	}
}

private extension ConversionsScreenView {
	func loadMore(index: Int) {
		
	}
	
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
