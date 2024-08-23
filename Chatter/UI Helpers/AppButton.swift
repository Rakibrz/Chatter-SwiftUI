//
//  AppButton.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI

struct AppButton: View {
	let title: String
	var disabled: Bool = false
	let onTap: () -> Void
	
    var body: some View {
		Button {
			onTap()
		} label: {
			Text(title)
				.font(.appFont().weight(.semibold))
				.frame(maxWidth: .infinity)
				.padding(.vertical)
		}
		.foregroundStyle(disabled ? Color.theme.lightGrey : Color.white)
		.background(disabled ? Color.theme.lightOrange : Color.theme.orange)
		.clipShape(.rect(cornerRadius: Constants.radius))
		.disabled(disabled)
    }
}

#Preview {
	VStack {
		AppButton(title: "Continue") { }
		AppButton(title: "Book now", disabled: true) { }
	}
}
