//
//  Date+Extension.swift
//  Chatter
//
//  Created by Rakib Rz  on 27-08-2024.
//

import Foundation

extension Date {
	func isSameDate(as date: Date) -> Bool {
		Calendar.appCalendar.isDate(self, inSameDayAs: date)
	}

}

extension Calendar {
	static var appCalendar: Calendar { Calendar.autoupdatingCurrent }
}
