//
//  AppDelegate.swift
//  Bluetooth
//
//  Created by Alexey Papin on 05.05.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	private let rootController = MainViewController()
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		window = UIWindow()
		window?.rootViewController = rootController
		window?.makeKeyAndVisible()
		
		return true
	}
}

