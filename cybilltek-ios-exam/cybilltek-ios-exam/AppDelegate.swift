//
//  AppDelegate.swift
//  cybilltek-ios-exam
//
//  Created by John Kenneth Batoon on 6/8/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup Routing System
        Router.default.setupAppNavigation(appNavigation: NavigationRoute())
        
        // Initialize Navigation Controller
        window = UIWindow(frame: UIScreen.main.bounds)
        let initialVc = PersonsViewController(viewModel: .init(), mainView: .init())
        
        let navVC = NavigationController(rootViewController: initialVc)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        setupSwizzles()
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func setupSwizzles() {
        UILabel.setupSwizzle()
        UIButton.setupSwizzle()
    }
}

