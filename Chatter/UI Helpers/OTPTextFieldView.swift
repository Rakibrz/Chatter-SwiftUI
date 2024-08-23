//
//  OTPTextFieldView.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI
import Combine

struct OTPTextFieldView: View {
	@Binding var otpText: String
	var totalDigits: Int = 6
	
	@State private var digitList: [String] = Array(repeating: String(), count: 4)
	@FocusState private var focus : Int?
	
	var body: some View {
		HStack(spacing: .zero) {
			ForEach(digitList.indices, id: \.self) { index in
				if (index > 0 && index < digitList.count) {
					Spacer()
				}
				
				TextField(String(), text: $digitList[index])
					.multilineTextAlignment(.center)
					.keyboardType(.numberPad)
					.textContentType(.oneTimeCode)
					.font(.appFont(size: .large).weight(.bold))
					.focused($focus, equals: index)
					.padding(AppPadding.small)
					.clipShape(.rect(cornerRadius: Constants.radius))
					.roundedCorner(color: focus == index ? Color.accentColor : nil)
					.onChange(of: digitList[index]) { newValue in
						digitList[index] = String(newValue.prefix(1)) // Ensure only one character is entered
					}
			}
		}
		.onAppear {
			digitList = Array(repeating: String(), count: totalDigits)
		}
		.onChange(of: digitList) { newValue in
			withAnimation {
				guard let index = newValue.firstIndex(where: { $0.isNotEmpty == false }) else {
					otpText = digitList.joined()
					return
				}
				if index <= otpText.count {
					focus = index - 1
				} else {
					focus = index
				}
				otpText = digitList.joined()
			}
		}
	}
}

#Preview {
	@State var otp: String = String()
	return OTPTextFieldView(otpText: $otp)
}
