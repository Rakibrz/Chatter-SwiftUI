//
//  Constants.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import Foundation

typealias ValueCallback<Type: Any> = (Type) -> Void

enum Constants {
	/// 4px
	static let radius: CGFloat = 4
}

enum AppPadding {
	/// Value: 8
	static let small: CGFloat = 8
	/// Value: 12
	static let medium: CGFloat = 12
	/// Value: 16
	static let regular: CGFloat = 16
	/// Value: 24
	static let large: CGFloat = 24
}

enum StorageKey: String {
	case appState
}
