//
//  AppDelegate.swift
//  ShoppingList
//
//  Created by Lenochka on 8/25/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController(modelName: "ShoppingList")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        dataController.load()

        let navigationController = application.windows.first?.rootViewController as! UINavigationController
        let shoppingListsViewController = navigationController.topViewController as! ShoppingListsViewController
        shoppingListsViewController.dataController = dataController

        return true
    }

    // MARK: UISceneSession Lifecycle

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

        saveContext()
    }

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = dataController.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
