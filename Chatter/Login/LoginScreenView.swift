//
//  LoginScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

struct LoginScreenView: View {
	
	@StateObject private var viewModel: LoginViewModel = LoginViewModel()
	@AppStorage(StorageKey.appState.title) private var appState: AppState?
	
	var body: some View {
		VStack(spacing: AppPadding.small * 2) {
			VStack(spacing: AppPadding.small * 2) {
				AppTextField(title: "Phone number", text: $viewModel.phoneNumber, textContentType: .telephoneNumber, keyboardType: .numberPad)
					.onChange(of: viewModel.phoneNumber) { newValue in
						viewModel.phoneNumber = String(newValue.prefix(10))
						withAnimation {
							viewModel.otpSent = false
						}
					}
					.safeAreaInset(edge: .bottom, alignment: .leading) {
						if viewModel.otpSent {
							Text("✓ OTP has been sent to your number.")
								.foregroundStyle(Color.theme.green)
								.font(.appFont(size: .small))
						}
					}
				
				if viewModel.otpSent {
					OTPTextFieldView(otpText: $viewModel.otpText)
				}
			}
			.padding(AppPadding.large)
			.safeAreaInset(edge: .bottom) {
				if viewModel.otpSent == false {
					AppButton(title: "Send OTP") {
						Task {
							let response = await viewModel.sendOTP()
							withAnimation {
								viewModel.otpSent = response
							}
						}
					}
					.padding(AppPadding.large)
				} else {
					AppButton(title: "Verify OTP") {
						Task {
							let response = await viewModel.verifyOTP()
							if let response {
								let inCompleteProfile = response.displayName?.isEmpty ?? true
								await MainActor.run {
									appState = inCompleteProfile ? .setupProfile : .dashboard
								}
							}
						}
					}
					.padding(AppPadding.large)
				}
				
			}
			.background(Color.primary.colorInvert())
			.clipShape(RoundedRectangle(cornerRadius: Constants.radius * 3))
			.environment(\.colorScheme, .dark)
			.padding(AppPadding.large)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background {
			Ellipse()
				.fill(Color.theme.orange)
				.frame(width: AppSettingsManager.shared.screenSize.width * 1.5)
				.rotationEffect(.degrees(90))
				.offset(y: -AppSettingsManager.shared.screenSize.width)
		}
		.background(Color.theme.lightOrange)
		.ignoresSafeArea()
		.appBar(title: "Login")
		.ignoresSafeArea(.keyboard, edges: .bottom)
		.showLoader(when: viewModel.loading)
		.showAlert(message: viewModel.errorMessage, when: $viewModel.showError) {
			Button("OK") { }
		}
	}
}
#Preview {
	LoginScreenView()
		.applyDefaults()
}
