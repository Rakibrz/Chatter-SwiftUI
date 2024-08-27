//
//  TabbarScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI

struct TabbarScreenView: View {
	@State private var currentTab: TabItem = .home
	
	var body: some View {
		TabView(selection: $currentTab.animation()) {
			HomeScreenView(currentTab: $currentTab)
				.tag(TabItem.home)
			
			ChatsScreenView()
				.tag(TabItem.inbox)
			
			ProfileScreenView()
				.tag(TabItem.profile)
		}
		.hideDefaultNavigation()
		.safeAreaInset(edge: .bottom, spacing: AppPadding.small) {
			TabbarView(selectedTab: $currentTab)
				.padding(.bottom, getSafeArea().bottom.isZero ? AppPadding.regular : .zero)
				.padding(.horizontal, AppPadding.large)
		}
		.ignoresSafeArea(.keyboard, edges: .bottom)
	}
}

#Preview {
	NavigationStack {
		TabbarScreenView()
	}
	.applyDefaults()
}
