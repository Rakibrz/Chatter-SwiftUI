//
//  Color+Extension.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

extension Color {
	static let theme = AppColors()

	/// Custom init with HEX code
	init(hex: Int, opacity: Double = 1.0) {
		let red = Double((hex & 0xff0000) >> 16) / 255.0
		let green = Double((hex & 0xff00) >> 8) / 255.0
		let blue = Double((hex & 0xff) >> 0) / 255.0
		self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
	}

}

extension Color {
	
	/// Custom Colors provided in assets
	struct AppColors {
		let lightPink = Color("AppPinkLight")
		let pink = Color("AppPink")
		let lightOrange = Color("AppOrangeLight")
		let orange = Color("AppOrange")
		/// Hex Code: #DA5C5C
		let red = Color(hex: 0xDA5C5C)
		/// Hex Code: #FFB94E
		let yellow = Color(hex: 0xFFB94E)
		/// Hex Code: #06C167
		let green = Color(hex: 0x06C167)
		/// Hex Code: #AFAFAF
		let grey = Color("AppGray")
		/// Hex Code: #CBCBCB
		let lightGrey = Color(hex: 0xCBCBCB)
		/// Hex Code: #FFFFFF  30%
		let disabled = Color.primary.opacity(0.3)
	}
}
