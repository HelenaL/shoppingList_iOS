//
//  ShoppingList+Extension.swift
//  ShoppingList
//
//  Created by Lenochka on 8/25/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingList {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }

    func getUnfinishedCount(context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isBought == YES && shoppingList == %@", self)
        let count =  try? context.count(for: fetchRequest)
        return count ?? 0
    }
}
