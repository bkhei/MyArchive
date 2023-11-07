//
//  SceneDelegate.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // Storyboard navigation controller identities
    private enum NavID {
        static let loginNCID = "LoginNavigationController"
        static let homeNCID = "HomeNavigationController"
        static let storyboardID = "Main"
    }

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Observers to recieve notifications
        NotificationCenter.default.addObserver(forName: Notification.Name("login"), object: nil, queue: OperationQueue.main) {
            [weak self] _ in
            print("Logging user in")
            self?.login() // Calling login function
        }
        NotificationCenter.default.addObserver(forName: Notification.Name("logout"), object: nil, queue: OperationQueue.main) {
            [weak self] _ in
            print("Logging user out")
            self?.logout() // Calling logout function
        }
        
        // Check for cached user for persisted login
        // If there is a current user, log them in
        /*if User.current != nil {
            login()
        }*/

    }
    
    // Private login and logout functions
    private func login() {
        let storyboard = UIStoryboard(name: NavID.storyboardID, bundle: nil)
        // Changing root view controller from LoginViewController to HomeViewController
        print("Changing root view controller to home")
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: NavID.homeNCID)
    }
    private func logout() {
        // Logging out user (NOTE: User is a parse object), has access to logout() method
        User.logout {
            [weak self] result in
            
            switch result {
            case .success:
                // If logout successful...
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: NavID.storyboardID, bundle: nil)
                    // Setting root view controller from HomeViewController to LoginViewController
                    print("Changing root view controller to login")
                    self?.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: NavID.loginNCID)
                }
            case .failure(let error):
                // If logout unsuccessful...
                print("Logout error: \(error)")
            }
        }
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

