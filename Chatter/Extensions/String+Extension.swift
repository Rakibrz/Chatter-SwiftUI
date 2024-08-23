//
//  String+Extension.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import Foundation

extension String {
	var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
	
	var isNotEmpty: Bool { trimmed.isEmpty == false }
}

extension Optional where Wrapped == String {
	var isNotEmpty: Bool { self?.trimmed.isEmpty == false }
	
	func numberOnly() -> Self {
		return self?.numberOnly()
	}
}

extension RangeReplaceableCollection where Self: StringProtocol {
	func numberOnly() -> Self {
		return filter(\.isNumber)
	}
}

extension Hashable {
	var hasableTitle: String {
		let name = String(describing: self)
		return (name.components(separatedBy: "(").first ?? name).replacingOccurrences(of: "_", with: " ").capitalized
	}
}

extension RawRepresentable {
	var title: String {
		let name = String(describing: self)
		return (name.components(separatedBy: "(").first ?? name).replacingOccurrences(of: "_", with: " ").capitalized
	}
}
