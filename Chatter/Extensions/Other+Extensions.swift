//
//  Other+Extensions.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI

// Will use to write in optional empty value
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
	Binding(
		get: { lhs.wrappedValue ?? rhs },
		set: { lhs.wrappedValue = $0 }
	)
}

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: .none, from: .none, for: .none)
	}
	
	var activeWindowScene: UIWindowScene? {
		connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene
	}
}

extension UIDevice {
	var hasNotch: Bool {
		let bottom = safeArea.bottom
		return bottom.isZero == false
	}
	
	var safeArea: UIEdgeInsets {
		guard let screen = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene else { return .zero }
		guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
		return safeArea
	}
}
