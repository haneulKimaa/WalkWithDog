//
//  SceneDelegate.swift
//  WalkWithDog-story
//
//  Created by 김하늘 on 2020/12/13.
//

import UIKit
import KakaoSDKAuth
import KakaoOpenSDK
import GoogleSignIn
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    //var handle: AuthStateDidChangeListenerHandle?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)



    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let scheme = URLContexts.first?.url.scheme else { return }
        if scheme.contains("com.googleusercontent.apps") {
            GIDSignIn.sharedInstance().handle(URLContexts.first?.url)
        }
        guard let url = URLContexts.first?.url else {return}
            KOSession.handleOpen(url)
        guard let loginVC = self.storyboard.instantiateViewController(withIdentifier: "login") as? logInViewController else { return }
        //logInViewController.handle
        loginVC.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                guard let loginVC = self.storyboard.instantiateViewController(withIdentifier: "login") as? logInViewController else { return }
                self.window?.rootViewController = loginVC
                
                //VC2?.modalPresentationStyle = .fullScreen
            }
            else{
                guard let userinfoVC = self.storyboard.instantiateViewController(withIdentifier: "userInfoVC") as? UserInfoViewController else { return }
                userinfoVC.view.backgroundColor = UIColor.colorWithRGBHex(hex: 0xF5F5F5)
                self.window?.rootViewController = userinfoVC
                //VC2?.modalPresentationStyle = .fullScreen
            }
          // ...
        }
        }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        KOSession.handleDidBecomeActive()
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
        KOSession.handleDidEnterBackground()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

