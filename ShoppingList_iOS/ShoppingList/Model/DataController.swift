//
//  DataController.swift
//  ShoppingList
//
//  Created by Lenochka on 8/25/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import Foundation
import CoreData

class DataController {

    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var backgroundContext: NSManagedObjectContext!

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func configureContexts () {
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true

        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)),
                                               name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: viewContext)

        NotificationCenter.default.addObserver(self, selector: #selector(contextWillSave(_:)),
                                               name: Notification.Name.NSManagedObjectContextWillSave,
                                               object: viewContext)
    }

    func load (completion: (() -> Void)? = nil ) {
        persistentContainer.loadPersistentStores { (_, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext(interval: 3)
            self.configureContexts()
            completion?()
        }
    }

    @objc func contextObjectsDidChange(_ notification: Notification) {
        print(notification)
    }

    @objc func contextWillSave(_ notification: Notification) {
        print(notification)
    }
}

extension DataController {
    func autoSaveViewContext (interval: TimeInterval = 30) {
        guard interval > 0 else {
            print("Can not set interval")
            return
        }

        if viewContext.hasChanges {
            try? viewContext.save()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }

}
