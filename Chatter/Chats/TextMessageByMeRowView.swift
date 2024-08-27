//
//  TextMessageByMeRowView.swift
//  Chatter
//
//  Created by Rakib Rz  on 26-08-2024.
//

import SwiftUI

struct TextMessageByMeRowView: View {
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
		.padding(.horizontal)
		.padding(.vertical, AppPadding.small)
		.foregroundStyle(Color.theme.lightOrange)
		.background(Color.theme.orange)
		.clipShape(.rect(cornerRadius: Constants.radius * 2))
		.frame(maxWidth: AppSettingsManager.shared.screenSize.width * 0.8, alignment: .trailing)
		.frame(maxWidth: .infinity, alignment: .trailing)
	}
}

#Preview {
	VStack {
		TextMessageByMeRowView(message: .init(text: "me"))
		TextMessageByMeRowView(message: .init(text: "This text is by me"))
		TextMessageByMeRowView(message: .init(text: "This text is by me and I am checking length of the message by adding more pharse here...."))
	}
}
