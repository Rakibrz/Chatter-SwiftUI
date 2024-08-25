//
//  AppTextField.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

struct AppTextField: View {
	let title: String
	@Binding var text: String
	
	var isSecure: Bool = false
	var highlight: Bool = false
	var highlightColor: Color = Color.theme.orange
	
	var textContentType: UITextContentType? = nil
	var keyboardType: UIKeyboardType = .default
	
	var trailingIcon: Image? = Image(systemName: "xmark")
	var shallFocus: Bool = false
	var animate: Bool = true
	var onTrailingTap: VoidCallback? = nil
	
	@FocusState private var isFocused: Bool
	
	var body: some View {
		HStack(spacing: .zero) {
			ZStack(alignment: .leading) {
				Text(title)
					.font(.appFont())
					.foregroundColor(text.isEmpty ? nil : Color.theme.grey )
					.scaleEffect(text.isEmpty ? 1: 0.65, anchor: .leading)
					.offset(y: text.isEmpty ? 0 : -20)
				
				if isSecure {
					SecureField(String(), text: $text.animation())
						.focused($isFocused)
						.textContentType(textContentType)
						.keyboardType(keyboardType)
						.font(.appFont().weight(.semibold))
						.frame(height: 40)
				} else {
					TextField(String(), text: $text.animation())
						.focused($isFocused)
						.textContentType(textContentType)
						.keyboardType(keyboardType)
						.font(.appFont().weight(.semibold))
						.frame(height: 40)
				}
			}
			.animation(animate ? .default : nil, value: text.isEmpty)
			if let trailingIcon {
				Button {
					if let onTrailingTap {
						onTrailingTap()
					} else {
						text = String()
					}
				} label: {
					trailingIcon
						.foregroundColor(textContentType == .dateTime ? Color.primary : nil)
						.frame(maxWidth: 24, maxHeight: 24)
						.padding([.leading, .vertical], AppPadding.small)
				}
				.hide(when: text.isEmpty)
			}
		}
		.padding(AppPadding.medium)
		.roundedCorner(color: borderColor())
		.background {
			if highlight {
				highlightColor.opacity(0.15)
			}
		}
		.onChange(of: shallFocus) { newValue in
			isFocused = newValue
		}

	}
}

extension AppTextField {
	func borderColor() -> Color? {
		if isFocused {
			return Color.accentColor
		}
		return highlight ? highlightColor : nil
	}
}

#Preview {
	@State var text: String = String()
	return VStack {
		AppTextField(title: "Phone number", text: $text)
		AppTextField(title: "Phone number", text: $text)
	}
	.preferredColorScheme(.dark)
}
