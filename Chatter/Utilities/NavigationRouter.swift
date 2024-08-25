//
//  NavigationRouter.swift
//  Chatter
//
//  Created by Rakib Rz  on 23-08-2024.
//

import SwiftUI

enum AppState: String {
	case unknown
	case authentication
	case dashboard
	case setupProfile
	case logout
}

enum AppRoutes: Hashable {
	case authentication
	case dashboard
	case profile(isFromLogin: Bool)
	
	@ViewBuilder
	func view() -> some View {
		switch self {
		case .authentication:
			LoginScreenView()
		case .dashboard:
			TabbarScreenView()
		case .profile(let isFromLogin):
			ProfileScreenView(isFromLogin: isFromLogin)
		}
	}
}

class PageRouter<Generic: Hashable>: ObservableObject {
	
	@Published var paths: [Generic] = .init() {
		didSet {
			print("routes \(paths.map{ $0.hasableTitle })")
		}
	}
	
	func push(to route: Generic...) {
		Task(priority: .userInitiated) {
			await MainActor.run {
				withAnimation {
					paths.append(contentsOf: route)
				}
			}
		}
	}
	
	func pop(to route: Generic) {
		Task(priority: .userInitiated) {
			await MainActor.run {
				withAnimation {
					if let index = paths.lastIndex(of: route) {
						paths.removeSubrange((index+1)..<paths.endIndex)
					}
				}
			}
		}
	}
	
	func popToRoot() {
		Task(priority: .userInitiated) {
			await MainActor.run {
				withAnimation {
					paths.removeAll()
				}
			}
		}
	}
	
	func popToRoot(with route: Generic...) {
		Task(priority: .userInitiated) {
			await MainActor.run {
				withAnimation {
					paths = route
				}
			}
		}
	}
	
	func reset() {
		Task(priority: .userInitiated) {
			await MainActor.run {
				withAnimation {
					paths = []
				}
			}
		}
	}
}
