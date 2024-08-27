//
//  HomeScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 25-08-2024.
//

import SwiftUI

struct HomeScreenView: View {
	@EnvironmentObject private var router: PageRouter<AppRoutes>
	
	@StateObject private var viewModel: HomeViewModel = HomeViewModel()
	@StateObject private var chatViewModel: ChatViewModel = ChatViewModel()
	@Binding var currentTab: TabItem
	
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVGrid(columns: [.init(.flexible()), .init(.flexible()), .init(.flexible())], spacing: AppPadding.small) {
				ForEach(viewModel.users, id:\.id) { user in
					VStack(spacing: AppPadding.small) {
						CircularProfileImageView(urlString: user.imageUrl(by: (AppSettingsManager.shared.screenSize.width / 3) * 0.5, rounded: true))
						Text(user.name)
							.multilineTextAlignment(.center)
							.font(.appFont())
							.fixedSize()
							.frame(maxHeight: .infinity)
						
						Button {
							startChat(with: user)
						} label: {
							Text("Chat")
								.padding(AppPadding.small / 2)
								.frame(maxWidth: .infinity)
						}
						.background {
							Capsule()
								.stroke(Color.theme.orange, lineWidth: 1.0)
						}
					}
					.padding()
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.background(Color.theme.lightOrange)
				.clipShape(.rect(cornerRadius: Constants.radius * 2))
			}
		}
		.scrollContentBackground(.hidden)
		.scrollBounceBehavior(.basedOnSize)
		.padding(.horizontal, AppPadding.regular)
		.appBar(title: "Users", tintColor: Color.theme.orange)
		.task {
			await viewModel.getUsers()
		}
		.showLoader(when: viewModel.loading || chatViewModel.loading)
		.showAlert(message: viewModel.errorMessage, when: $viewModel.showError) {
			Button("Ok") { }
		}
		.showAlert(message: chatViewModel.errorMessage, when: $chatViewModel.showError) {
			Button("Ok") { }
		}
	}
}

private extension HomeScreenView {
	
	func startChat(with profile: UserProfile) {
		Task {
			if let chat = await chatViewModel.createChat(with: profile) {
				withAnimation {
					currentTab = .inbox
					router.push(to: .messages(chat: chat))
				}
			}
			
		}
	}
}

#Preview {
	HomeScreenView(currentTab: .constant(.home))
		.applyDefaults()
}
