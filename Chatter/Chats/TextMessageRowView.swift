//
//  TextMessageRowView.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import SwiftUI

struct TextMessageRowView: View {
	let message: ChatMessage
	
    var body: some View {
		VStack(alignment: .trailing, spacing: AppPadding.small / 2) {
			if let text = message.text {
				Text(text)
					.font(.appFont())
					.frame(minWidth: 100, alignment: .leading)
			}
			
			Text(message.date, style: .time)
				.font(.appFont(size: .small))
		}
		.designMessageView(sendByMe: message.sendByMe)
    }
}

private extension View {
	func designMessageView(sendByMe: Bool) -> some View {
		padding(.horizontal, AppPadding.small)
		.padding(.vertical, AppPadding.small)
		.foregroundStyle(sendByMe ? Color.theme.lightOrange : Color.theme.orange)
		.background(sendByMe ? Color.theme.orange : Color.theme.lightOrange)
		.clipShape(.rect(cornerRadii: .init(topLeading: Constants.radius * 2, bottomLeading: sendByMe ? Constants.radius * 2 : .zero, bottomTrailing: sendByMe ? .zero : Constants.radius * 2, topTrailing: Constants.radius * 2)))
//		.clipShape(.rect(cornerRadius: Constants.radius * 2))
		.frame(maxWidth: AppSettingsManager.shared.screenSize.width * 0.8, alignment: sendByMe ? .trailing : .leading)
		.frame(maxWidth: .infinity, alignment: sendByMe ? .trailing : .leading)
	}
}

#Preview {
	VStack {
		TextMessageRowView(message: .init(text: "This text is by sender"))
		TextMessageRowView(message: .init(text: "This text is by sender"))
		TextMessageRowView(message: .init(text: "This text is by sender and I am checking length of the message by adding more pharse here...."))
		TextMessageRowView(message: .init(text: "This text is by sender and I am checking length of the message by adding more pharse here...."))
	}
}
