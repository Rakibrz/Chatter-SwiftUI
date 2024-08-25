//
//  FirstAppearModifier.swift
//  Chatter
//
//  Created by Rakib Rz  on 24-08-2024.
//

import SwiftUI

struct FirstAppearModifier: ViewModifier {
	let action: VoidCallback
	
	// Use this to only fire your block one time
	@State private var hasAppeared = false
	
	func body(content: Content) -> some View {
		// And then, track it here
		content
			.onAppear {
				guard !hasAppeared else { return }
				hasAppeared = true
				action()
			}
	}
}
