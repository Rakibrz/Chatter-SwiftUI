//
//  HomeScreenView.swift
//  Chatter
//
//  Created by Rakib Rz  on 25-08-2024.
//

import SwiftUI

struct HomeScreenView: View {
	var body: some View {
		Text("Home")
			.appNavigationBar(title: "Home")
	}
}

#Preview {
	NavigationStack {
		HomeScreenView()
	}
	.applyDefaults()
}
