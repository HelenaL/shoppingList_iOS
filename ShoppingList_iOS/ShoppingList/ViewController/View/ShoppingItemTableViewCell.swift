//
//  ShoppingItemTableViewCell.swift
//  ShoppingList
//
//  Created by Lenochka on 8/28/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit

protocol ShoppingItemTableViewCellDelegate: class {
    func shoppingItemTableViewCell(cell: ShoppingItemTableViewCell,
                                   didChangeValue value: Bool,
                                   indexPath: IndexPath)
}

class ShoppingItemTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buySwitch: UISwitch!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!

    var indexPath: IndexPath!
    weak var delegate: ShoppingItemTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        photoImageView.layer.cornerRadius = photoImageView.bounds.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - UI Setup Cell

    func fill(shoppingItem: ShoppingItem!) {

        nameLabel.text = shoppingItem.name!.capitalized
        buySwitch.isOn = !(shoppingItem.isBought)

        if let data = shoppingItem.image, let image = UIImage(data: data) {
            photoImageView.image = image
        } else {
             photoImageView.image = nil
        }

        if Int(shoppingItem.category) > 0 {
            categoryNameLabel.text = Categories.categories[Int(shoppingItem.category)]
        } else {
            categoryNameLabel.text = ""
        }

        setEnabled(isEnable: !(shoppingItem.isBought))
    }

    func setEnabled(isEnable: Bool) {
        nameLabel.isEnabled = isEnable
        photoImageView.alpha = isEnable ? 1 : 0.5
    }

    @IBAction func switchValueChangeAction(_ sender: Any) {
        self.delegate?.shoppingItemTableViewCell(cell: self,
                                                 didChangeValue: buySwitch.isOn,
                                                 indexPath: indexPath)
        setEnabled(isEnable: buySwitch.isOn)
    }
}
