//
//  TabItemView.swift
//  Chatter
//
//  Created by Rakib Rz  on 25-08-2024.
//

import SwiftUI

enum TabItem: String, CaseIterable {
	case home 		= "Home"
	case inbox		= "Chat"
	case profile	= "Profile"
	
	var icon: String {
		switch self {
		case .home:
			"tab_home"
		case .inbox:
			"tab_chat"
		case .profile:
			"tab_profile"
		}
	}
	
}

struct TabItemView: View {
	let tab: TabItem
	let isSelected: Bool
	var body: some View {
		HStack(spacing: AppPadding.small / 2) {
			Image(tab.icon)
				.resizable()
				.scaledToFit()
				.frame(width: 28)
			if isSelected {
				Text(tab.rawValue)
					.font(.appFont(size: .medium))
					.fontWeight(.semibold)
			}
		}
		.foregroundStyle(isSelected ? Color.black : Color.white)
		
	}
}

#Preview {
	TabItemView(tab: .inbox, isSelected: true)
}
