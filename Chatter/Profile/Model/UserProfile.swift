//
//  UserProfile.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Codable, Identifiable, Hashable {
	@DocumentID var id: String?
	var phoneNumber, name: String
	var date: Date = .now
	
	func imageUrl(by size: CGFloat, rounded: Bool = true) -> String {
		guard name.isNotEmpty else { return name }
		let nameList = name.capitalized.components(separatedBy: .whitespacesAndNewlines).prefix(2)
		let initials = nameList.joined(separator: "+")
		var components = String("?name=\(initials)&length=\(nameList.count)&rounded=\(rounded)&color=ffffff")

		if let firstCharacter = name.first {
			let background = pickColor(alphabet: firstCharacter).replacingOccurrences(of: "#", with: "")
			components.append("&background=\(background)")
		}

		return Constants.avatarUrl + components
	}
}

extension UserProfile {
	func pickColor(alphabet: Character) -> String {
		let alphabetColors = ["#5A8770", "#B2B7BB", "#6FA9AB", "#F5AF29", "#0088B9", "#F18636", "#D93A37", "#A6B12E", "#5C9BBC", "#F5888D", "#9A89B5", "#407887", "#9A89B5", "#5A8770", "#D33F33", "#A2B01F", "#F0B126", "#0087BF", "#F18636", "#0087BF", "#B2B7BB", "#72ACAE", "#9C8AB4", "#5A8770", "#EEB424", "#407887"]
		let str = String(alphabet).unicodeScalars
		let unicode = Int(str[str.startIndex].value)
		if 65...90 ~= unicode {
			let hex = alphabetColors[unicode - 65]
			return hex
		}
		return "#FFFFFF"
	}
}
