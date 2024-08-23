//
//  AppSettingsManager.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

class AppSettingsManager: ObservableObject {
	static let shared: AppSettingsManager = AppSettingsManager()

	@Published var scenePhase: ScenePhase = .active
	@Published var screenSize: CGSize = UIScreen.main.bounds.size

	private init() { }
}
