//
//  ProgressLoaderModifier.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI

struct ProgressLoaderModifier: ViewModifier {
	
	let active: Bool
	
	func body(content: Content) -> some View {
		content
			.disabled(active)
			.overlay {
				if active {
					LoaderView(thickness: 2)
				}
			}
	}
}
