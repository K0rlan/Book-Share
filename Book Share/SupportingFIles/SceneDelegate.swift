//
//  SceneDelegate.swift
//  Book Share
//
//  Created by Korlan Omarova on 04.03.2021.
//

import UIKit
import Griffon_ios_spm

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let home = TabBar()
        window?.rootViewController = home
        window?.makeKeyAndVisible()
    }

    private func setGriffonConfig() {
        let griffon = Griffon.shared
        let config = GriffonConfigurations(clientId: "bba272c2-6a07-4bd1-9bc9-aab174a90a51",
                                           brand: "c481873c-ae55-48bb-ada9-aec89c5b76e2",
                                           bucket: "2881a298-4951-4a6e-855d-ff4184349fdd",
                                           clientSecret: "EWBh1XuiJjSCu9uG0Jmq4xGkOdLKFKg5nURpDq0IBKmqHcP3WsyaSjRXa-dOfLoy", url: "https://griffon.dar-dev.zone/api/v1")
        griffon.config = config
        NetworkManager.instance.config = config
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }


}

