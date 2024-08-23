//
//  LoginScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

struct LoginScreenView: View {
	@State private var phoneNumber: String = String()
	@State private var otpSent: Bool = false
	@State private var otpText: String = String()
    var body: some View {
		VStack(spacing: AppPadding.regular) {
			VStack(spacing: AppPadding.regular) {
				AppTextField(title: "Phone number", text: $phoneNumber, textContentType: .telephoneNumber, keyboardType: .numberPad)
					.onChange(of: phoneNumber) { newValue in
						phoneNumber = String(newValue.prefix(10))
					}
					.safeAreaInset(edge: .bottom, alignment: .leading) {
						if otpSent {
							Text("✓ OTP has been sent to your number.")
							.foregroundStyle(Color.theme.green)
							.font(.appFont(size: .small))
						}
					}
				
				if otpSent {
					OTPTextFieldView(otpText: $otpText)
				}
			}
			.padding(AppPadding.large)
			.safeAreaInset(edge: .bottom) {
				AppButton(title: "Send OTP") {
					withAnimation {
						otpSent.toggle()
					}
				}
				.padding(AppPadding.large)
			}
			.background(Color.primary.colorInvert())
			.clipShape(RoundedRectangle(cornerRadius: Constants.radius * 3))
			.environment(\.colorScheme, .dark)
			.padding(AppPadding.large)
//			.frame(maxHeight: .infinity, alignment: .bottom)
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
		.safeAreaInset(edge: .top) {
			Text("Login")
				.foregroundStyle(Color.theme.lightOrange)
				.font(.appFont(size: .custom(value: 35)).weight(.black))
		}
    }
}

#Preview {
	LoginScreenView()
		.applyDefaults()
}
