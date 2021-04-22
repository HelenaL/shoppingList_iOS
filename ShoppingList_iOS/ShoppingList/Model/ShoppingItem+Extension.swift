//
//  ShoppingItem+Extension.swift
//  ShoppingItem
//
//  Created by Lenochka on 8/25/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import Foundation

extension ShoppingItem {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }
}
