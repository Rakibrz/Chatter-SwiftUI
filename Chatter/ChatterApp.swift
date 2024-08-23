//
//  ChatterApp.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI

@main
struct ChatterApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate

    var body: some Scene {
        WindowGroup {
			GeometryReader { proxy in
				RootScreenView()
					.onAppear {
						AppSettingsManager.shared.screenSize = proxy.size
					}
			}
        }
    }
}

struct RootScreenView: View {
	@Environment(\.scenePhase) private var scenePhase
	
	var body: some View {
		LoginScreenView()
//		CircularProfileImageView(urlString: String())
			.applyDefaults() /// - Note: default tint for buttons, Textfields
			.onChange(of: scenePhase) { newPhase in
				print("Previous Phase: \(AppSettingsManager.shared.scenePhase)")
				AppSettingsManager.shared.scenePhase = newPhase
				print("New Phase: \(AppSettingsManager.shared.scenePhase)")
			}

	}
}
