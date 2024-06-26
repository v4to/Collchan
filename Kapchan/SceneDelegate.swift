//
//  SceneDelegate.swift
//  Makaba
//
//  Created by Andrii Yehortsev on 21.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        
//        UINavigationBar.appearance().isTranslucent = true
        
        
//        let stackViewAppearance = UIStackView.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
//        stackViewAppearance.spacing = -5
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = Constants.Design.Color.backgroundWithOpacity
        
        UITabBar.appearance().tintColor = Constants.Design.Color.orange
        
//        let label = UILabel.appearance(whenContainedInInstancesOf: [BoardsListTableViewCell.self])
//        label.textColor = Constants.Design.Color.orange
//        UITableViewCell.appearance().textLabel?.textColor = Constants.Design.Color.orange
//        let barButtonAppearance = UINavigationBar.appearance()
        UINavigationBar.appearance().tintColor = Constants.Design.Color.orange
        
        
        UIBarButtonItem.appearance().tintColor = Constants.Design.Color.orange
        let tabBarController = UITabBarController()
        let savedViewController = FavoritesViewController()
        let historyViewController = HistoryViewController()
        let boardsNavigationViewController = UINavigationController(
            rootViewController: BoardsTableViewController(
                style: UITableView.Style.insetGrouped
            )
        )
        
        
        
        
//        boardsNavigationViewController.toolbar.isTranslucent = false
//        boardsNavigationViewController.toolbar.
        let settingsViewController = SettingsViewController()
        tabBarController.viewControllers = [
            boardsNavigationViewController,
            savedViewController,
            historyViewController,
            settingsViewController
        ]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

