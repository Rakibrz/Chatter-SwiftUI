//
//  TabbarView.swift
//  Chatter
//
//  Created by Rakib Rz  on 25-08-2024.
//

import SwiftUI

struct TabbarView: View {
	@Binding var selectedTab: TabItem
	
	@Namespace private var tabAnimation
	private let tabItems: [TabItem] = TabItem.allCases
	
	var body: some View {
		HStack(spacing: .zero) {
			ForEach(tabItems, id:\.rawValue) { tab in
				TabItemView(tab: tab, isSelected: selectedTab == tab)
					.padding(.vertical, AppPadding.small)
					.frame(maxWidth: .infinity)
					.onTapGesture {
						withAnimation {
							selectedTab = tab
						}
					}
					.background {
						if selectedTab == tab {
							Capsule()
								.fill(Color.theme.lightOrange.gradient)
								.matchedGeometryEffect(id: "selectedTab", in: tabAnimation)
						}
					}
					.clipShape(.capsule)
			}
			.frame(maxWidth: .infinity)
		}
		.animation(.smooth(), value: selectedTab)
		.padding(AppPadding.small)
		.background(Color.theme.orange)
		.clipShape(.capsule)
	}
}

#Preview {
	@State var item = TabItem.inbox
	return TabbarView(selectedTab: $item)
}
