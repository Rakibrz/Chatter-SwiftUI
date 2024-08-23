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
}
