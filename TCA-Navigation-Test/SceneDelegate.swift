//
//  SceneDelegate.swift
//  TCA-Navigation-Test
//
//  Created by Matt Darnall on 2/18/25.
//

import UIKit
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window = (scene as? UIWindowScene).map { UIWindow(windowScene: $0) }
        
        self.window?.rootViewController =
        StaticNavigationStackController(
            store: Store(initialState: RootFeature.State()) {
                RootFeature()
            }
        )
        self.window?.makeKeyAndVisible()
    }

}

