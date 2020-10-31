//
//  HeadhuntrApp.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/22/20.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct HeadhuntrApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        configureAmplify()
        
        return true
    }
    
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify Configured!")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
    }
}
