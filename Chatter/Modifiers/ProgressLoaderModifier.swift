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
					LoaderView(thickness: 3)
						.frame(width: AppPadding.medium*2, height: AppPadding.medium*2)
				}
			}
	}
}
