//
//  ShoppingListTableViewCell.swift
//  ShoppingList
//
//  Created by Lenochka on 8/25/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var nameListLabel: UILabel!
    @IBOutlet var countItemsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priorityImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: - UI Setup Cell

    func fill(shoppingList: ShoppingList!, boughtCount: Int) {
        nameListLabel.text = shoppingList.name?.capitalized
        dateLabel.text = shoppingList.createdAt!.toString(dateFormat: "MM/dd/YYYY")

        // set number of items in list
        if let count = shoppingList.shoppingItems?.count {
            countItemsLabel.text = "\(NSLocalizedString("Label_Items_Count", comment: "")) \(count)  \(NSLocalizedString("Label_Items_Bought_Count", comment: "")) \(boughtCount)"
        }

        // set priority color of list
        priorityImageView.backgroundColor = priorityColor(priority: Int(shoppingList.priority))
    }

    func priorityColor(priority: Int) -> UIColor {
        switch priority {
            case 0:
                return UIColor.grayNoPriority()
            case 1:
                return UIColor.greenLowPriority()
            case 2:
                return UIColor.orangeMiddlePriority()
            case 3:
                return UIColor.redHighPriority()
        default:
            return UIColor.grayNoPriority()
        }
    }

}
