//
//  SceneDelegate.swift
//  Join
//
//  Created by 이윤진 on 2022/04/20.
//

import UIKit

import KakaoSDKAuth
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var inviteUserId: Int?
    var isInvited: Bool = false
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
            
            print("url : \(url)")
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
            
            let userId = queryItems?.filter({$0.name == "inviteUserId"}).first?.value!
            inviteUserId = Int(userId!)!
            isInvited = true
            
            linkToProfile()
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let vc = SplashVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        if let userActivity = connectionOptions.userActivities.first {
          self.scene(scene, continue: userActivity)
        } else {
          self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { [self] dynamicLink, error in
                /* 다이나믹 링크 핸들링 */
                guard let dynamicLink = dynamicLink else {
                    return
                }

                let queryItems = URLComponents(url: dynamicLink.url!, resolvingAgainstBaseURL: true)?.queryItems
                let userId = queryItems?.filter({$0.name == "userId"}).first?.value!
                inviteUserId = Int(userId!)!
                isInvited = true
                                
                linkToProfile()
                
            }
            
        }
    }
    
    //링크 진입 시 탭바 -> 프로필 화면으로 이동
    func linkToProfile(){
        
        let tabBarVC: TabBarController = TabBarController()

        self.window?.rootViewController = tabBarVC
        self.window?.makeKeyAndVisible()
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

