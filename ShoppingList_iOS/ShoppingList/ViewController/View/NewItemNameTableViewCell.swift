//
//  NewItemNameTableViewCell.swift
//  ShoppingList
//
//  Created by Lenochka on 8/29/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit

protocol NewItemNameTableViewCellDelegate: class {
    func newItemNameTableViewCell(sender: Any, didChangeText text: String?)
}

class NewItemNameTableViewCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - Properties

    weak var delegate: NewItemNameTableViewCellDelegate?

    @IBOutlet weak var nameTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification), name: UITextField.textDidChangeNotification, object: nameTextField)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func textDidChangeNotification(_ notif: Notification) {
        self.delegate?.newItemNameTableViewCell(sender: self, didChangeText: nameTextField.text)
    }
}
