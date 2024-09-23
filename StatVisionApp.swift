//
//  StatVisionApp.swift
//  StatVision
//
//  Created by Noah Torres on 8/2/23.
//

import SwiftUI
import Firebase
import FirebaseCore


@main
struct StatVisionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Create a single instance of sm
    @StateObject private var smObject = sm()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(smObject) // Pass smObject to ContentView's environment
            TeamView()
                .environmentObject(smObject) // Pass the same smObject to TeamView's environment
            ChatBotView()
                .environmentObject(smObject) // Pass the same smObject to ChatBotView's environment
            GameSelect()
                .environmentObject(smObject) // Pass the same smObject to GameSelect's environment
        }
    }
    
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
            
            return true
    }
    
    private func checkAdminPrivileges(_ user: User) {
            // In a real app, you might fetch user claims or another method to verify admin status
            if user.uid == "UID_OF_ADMIN" {
                print("User is admin")
                // Proceed with admin operations
            } else {
                print("User is not admin")
            }
        }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // Set up the root view controller (e.g., your main ContentView)
        let rootView = ContentView()
            .environmentObject(sm()) // Initialize and inject shared environment object
        
        window.rootViewController = UIHostingController(rootView: rootView)
        self.window = window
        window.makeKeyAndVisible()
    }

    // Other methods for handling scene lifecycle events, state restoration, etc.
}

