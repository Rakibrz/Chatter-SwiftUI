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
	@StateObject private var router: PageRouter<AppRoutes> = PageRouter()
	@AppStorage(StorageKey.appState.title) private var storageAppState: AppState?

	@State private var appState: AppState = .unknown

	var body: some View {
		Group {
			switch appState {
			case .authentication, .logout:
				LoginScreenView()
			case .dashboard:
				NavigationStack(path: $router.paths) {
					TabbarScreenView()
					.navigationDestination(for: AppRoutes.self) { route in
						route.view()
					}
				}
				.environmentObject(router)
				.transition(.move(edge: .trailing).combined(with: .opacity))

			default:
				VStack {
					ProgressView()
						.padding()
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.task {
					DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
						let isLoggedIn = LoginViewModel.user != nil
						appState = isLoggedIn ? .dashboard : .authentication
					}
				}
			}
		}
		.applyDefaults() /// - Note: default tint for buttons, Textfields
		.onChange(of: storageAppState) { newValue in
			print("onChange storageAppState: \(newValue ?? .unknown)")
			withAnimation {
				if newValue == .logout {
					router.reset()
				}
				appState = newValue ?? .unknown
			}
		}
		.onChange(of: scenePhase) { newPhase in
			print("Previous Phase: \(AppSettingsManager.shared.scenePhase)")
			AppSettingsManager.shared.scenePhase = newPhase
			print("New Phase: \(AppSettingsManager.shared.scenePhase)")
		}
	}
}
