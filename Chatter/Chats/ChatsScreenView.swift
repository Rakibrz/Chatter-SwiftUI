//
//  ChatsScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 25-08-2024.
//

import SwiftUI

struct ChatsScreenView: View {
	var body: some View {
		List {
			
		}
		.listStyle(.plain)
		.appBar(title: "Chats", tintColor: Color.theme.orange)
	}
}

#Preview {
	ChatsScreenView()
		.applyDefaults()
}
