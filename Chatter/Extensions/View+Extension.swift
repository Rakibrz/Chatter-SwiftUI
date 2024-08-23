//
//  View+Extension.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

extension View {
	
	func roundedCorner(radius: CGFloat = Constants.radius, border width: CGFloat = 1.5, color: Color? = nil) -> some View {
		background {
			RoundedRectangle(cornerRadius: radius)
			//                .strokeBorder(color ?? Color.theme.disabled, lineWidth: width) // Inside Borders
				.stroke(color ?? Color.theme.disabled, lineWidth: width)
		}
		.clipShape(RoundedRectangle(cornerRadius: radius))
	}

	/// Get safe area Insets of the device
	func getSafeArea() -> UIEdgeInsets {
		let safeArea = UIDevice.current.safeArea
		return safeArea
	}

	/// Hide view with condition
	func hide(when hide: Bool) -> some View {
		hide ? AnyView(hidden()) : AnyView(self)
	}

	/// Read the size of the specific view
	func readSize(onChange: @escaping ValueCallback<CGSize>) -> some View {
		background(
			GeometryReader { proxy in
				Color.clear
					.preference(key: SizePreferenceKey.self, value: proxy.size)
			}
		)
		.onPreferenceChange(SizePreferenceKey.self, perform: onChange)
	}
	
	/// Read the frame of the specific view
	func readFrame(coordinateSpace: CoordinateSpace = .global, onChange: @escaping ValueCallback<CGRect>) -> some View {
		background(
			GeometryReader { proxy in
				Color.clear
					.preference(key: FramePreferenceKey.self, value: proxy.frame(in: coordinateSpace))
			}
		)
		.onPreferenceChange(FramePreferenceKey.self, perform: onChange)
	}
	
	func applyDefaults() -> some View {
		tint(Color.accentColor)
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

