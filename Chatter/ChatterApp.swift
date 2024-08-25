//
//  ChatterApp.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import SwiftUI
import FirebaseCore

@main
struct ChatterApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
	
	init() {
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
			// SwiftUI Preview is running.
			FirebaseConfiguration.shared.setLoggerLevel(.min)
			FirebaseApp.configure()
		}
	}
	
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
					.applyDefaults()
			case .setupProfile:
				ProfileScreenView(isFromLogin: true)
					.applyDefaults()
					.transition(.move(edge: .trailing).combined(with: .opacity))
				
			case .dashboard:
				NavigationStack(path: $router.paths) {
					TabbarScreenView()
						.navigationDestination(for: AppRoutes.self) { route in
							route.view()
						}
				}
				.applyDefaults() /// - Note: default tint for buttons, Textfields
				.environmentObject(router)
				.transition(.move(edge: .trailing).combined(with: .opacity))
			default:
				VStack {
					ProgressView()
						.padding()
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.task {
					await LoginViewModel.retriveUser()
					DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
						guard let user = FirestoreUserDatabase.user else {
							storageAppState = .authentication
							return
						}
						
						let inCompleteProfile = user.displayName?.isEmpty ?? true
						storageAppState = inCompleteProfile ? .setupProfile : .dashboard
					}
				}
			}
		}
		.applyDefaults() /// - Note: default tint for buttons, Textfields
		.dismissKeyboardOnTap()
		.onFirstAppear {
			storageAppState = nil
		}
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
