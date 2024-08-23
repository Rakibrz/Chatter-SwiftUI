//
//  AppDelegate.swift
//  Chatter
//
//  Created by Rakib Rz  on 22-08-2024.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
		sceneConfig.delegateClass = SceneDelegate.self
		application.applicationIconBadgeNumber = 0
		return sceneConfig
	}
}

/// Notifications should be handled from Scene Delegate only.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		FirebaseConfiguration.shared.setLoggerLevel(.min)
		FirebaseApp.configure()
	}
}
