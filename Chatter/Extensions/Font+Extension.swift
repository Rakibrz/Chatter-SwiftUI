//
//  Font+Extension.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

/// Predefined font sizes to use within app
enum AppFontSize {
	/// Value: 12
	case small
	/// Value: 14
	case medium
	/// Value: 16
	case regular
	/// Value: 24
	case large
	/// Any size provided as value
	case custom(value: CGFloat)
	
	fileprivate var value: CGFloat {
		switch self {
		case .small:
			return 12
		case .medium:
			return 14
		case .regular:
			return 16
		case .large:
			return 24
		case .custom(let value):
			return value
		}
	}
}

extension Font {
	static private let fontFamily = "Barlow"
	
	/** Set app fonts with custom family with `default size: .regular (16)`
	 - Returns: Custom font that uses the size you specify.
	 */
	static func appFont(size: AppFontSize = .regular) -> Font {
		return Font.custom(fontFamily, size: size.value)
	}
}
