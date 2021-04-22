//
//  ShoppingItemDetailsViewController.swift
//  ShoppingList
//
//  Created by Lenochka on 9/1/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit
import CoreData

class ShoppingItemDetailsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var categoryLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsLabelConstraint: NSLayoutConstraint!

    var dataController: DataController!
    var selectedShoppingItem: ShoppingItem?

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = selectedShoppingItem {
            setupUI(item: item)
        }
    }

     // MARK: - UI Setup

    func setupUI(item: ShoppingItem) {
        nameLabel.text = item.name?.capitalized ?? ""

        if Int(item.category) > 0 {
            categoryLabel.text = Categories.categories[Int(item.category)]
        } else {
            categoryLabel.text = ""
            categoryLabelConstraint.constant = 0
        }

        if let details = item.details {
            detailsLabel.text = details
        } else {
            detailsLabel.text = ""
            detailsLabelConstraint.constant = 0
        }

        if let data = item.image, let image = UIImage(data: data) {
            photoImageView.image = image
        } else {
             photoImageView.image = nil
        }

        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
    }

}
