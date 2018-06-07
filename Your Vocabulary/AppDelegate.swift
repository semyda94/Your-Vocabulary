//
//  AppDelegate.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 4/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        // Getting standart window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //getting Main storyboard
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        /****************************************************************************
         ****** Checking of was omboarding complited or not from user defaults ******
         ****************************************************************************/
        if UserDefaults.standard.bool(forKey: "onboardingWasComplited") {
            // If onboarding was finished to present a Dictionaries view Controller
            window?.rootViewController = sb.instantiateViewController(withIdentifier: "MainApp")
        } else {
            // If application started first time then present onboarding view.
            window?.rootViewController = sb.instantiateViewController(withIdentifier: "AppOnboarding")
            window?.makeKeyAndVisible()
        }
        
        /***************************************************************
         ****** Removing of realm database from application files ******
         ***************************************************************/
        /*
         let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
         let realmURLs = [
         realmURL,
         realmURL.appendingPathExtension("lock"),
         realmURL.appendingPathExtension("note"),
         realmURL.appendingPathExtension("management")
         ]
         for URL in realmURLs {
         do {
         try FileManager.default.removeItem(at: URL)
         } catch {
         // handle error
         }
         }
        */
        
        
        /********************************************
         ****** Setting of realm configuration ******
         ********************************************/
        
        let config = Realm.Configuration(
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                // Any migration logic older Realm files may need
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        //Shows current version of realm
        print("Realm schem version: \(Realm.Configuration.defaultConfiguration.schemaVersion)")
    
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)], for: .selected)
        */
        
        
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

}

