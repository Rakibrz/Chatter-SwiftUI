//
//  Font+Extension.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

/// Predefined font sizes to use within app
enum AppFontSize {
	/// Caption 2 = 11
	case small
	/// Sub Head = 14
	case medium
	/// Body = 17
	case regular
	/// Title 2 = 22
	case large
	/// Any size provided as value
	case custom(value: CGFloat)
	
	fileprivate var value: CGFloat {
		switch self {
		case .small:
			return 11
		case .medium:
			return 14
		case .regular:
			return 17
		case .large:
			return 22
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
