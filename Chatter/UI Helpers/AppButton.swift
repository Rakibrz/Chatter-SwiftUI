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
	var borderOnly: Bool = false
	let onTap: VoidCallback
	
    var body: some View {
		Button {
			onTap()
		} label: {
			Text(title)
				.font(.appFont().weight(.semibold))
				.frame(maxWidth: .infinity)
				.padding(.vertical)
		}
		.buttonStyle(.borderedProminent)
		.buttonBorderShape(.roundedRectangle(radius: Constants.radius))
		.disabled(disabled)
		.tint(Color.accentColor)
    }
}

#Preview {
	VStack {
		AppButton(title: "Continue") { }
		AppButton(title: "Book now", disabled: true) { }
	}
}
