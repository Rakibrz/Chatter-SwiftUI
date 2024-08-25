//
//  ProfileScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI

struct ProfileScreenView: View {
	@StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
	@AppStorage(StorageKey.appState.title) private var appState: AppState?
	
	var isFromLogin: Bool = false
	
	var body: some View {
		VStack(spacing: AppPadding.regular) {
			VStack(spacing: AppPadding.regular) {
				CircularProfileImageView(urlString: viewModel.user.imageUrl(by: AppSettingsManager.shared.screenSize.width * 0.4, rounded: true), size: .large)
				
				AppTextField(title: "Full Name", text: $viewModel.user.name, textContentType: .name)
					.onChange(of: viewModel.user.name) { newValue in
						viewModel.user.name = newValue.capitalized
					}
				
				AppTextField(title: "Phone Number", text: $viewModel.user.phoneNumber, textContentType: .telephoneNumber, trailingIcon: nil)
					.disabled(true)
					.safeAreaInset(edge: .bottom) {
						Text("You can’t change your phone number")
							.font(.appFont(size: .small))
							.foregroundColor(Color.theme.grey)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
			}
			.padding(AppPadding.large)
			.safeAreaInset(edge: .bottom) {
				AppButton(title: isFromLogin ? "Continue" : "Update") {
					Task {
						await viewModel.updateProfile()
					}
				}
				.padding(AppPadding.large)
			}
			.background(Color.primary.colorInvert())
			.clipShape(RoundedRectangle(cornerRadius: Constants.radius * 3))
			.environment(\.colorScheme, .dark)
			.padding(AppPadding.large)
			.task {
				await viewModel.getProfile()
			}
		}
		.ignoresSafeArea()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background {
			Ellipse()
				.fill(Color.theme.orange)
				.frame(width: AppSettingsManager.shared.screenSize.width * 1.5)
				.rotationEffect(.degrees(90))
				.offset(y: -AppSettingsManager.shared.screenSize.width)
		}
		.background(Color.theme.lightOrange)
		.appBar(title: "Profile", trailing: {
			Button(action: {
				ProfileViewModel.logout()
			}, label: {
				Text("Logout")
					.foregroundStyle(Color.white)
					.font(.appFont().weight(.semibold))
			})
		})
		.ignoresSafeArea(.keyboard, edges: .bottom)
		.showLoader(when: viewModel.loading)
		.showAlert(message: viewModel.errorMessage, when: $viewModel.showError) {
			Button("OK") { }
		}
		.showAlert(title: "Success", message: viewModel.profileUpdateMessage, when: $viewModel.showSuccess) {
			Button("OK") {
				if isFromLogin {
					withAnimation {
						appState = .dashboard
					}
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		ProfileScreenView()
	}
	.applyDefaults()
}
