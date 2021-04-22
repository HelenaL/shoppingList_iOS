//
//  NewItemCategoryTableViewCell.swift
//  ShoppingList
//
//  Created by Lenochka on 8/29/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit

protocol NewItemCategoryTableViewCellDelegate: class {
    func newItemCategoryTableViewCellInteraptionBegun(sender: Any)
}

class NewItemCategoryTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties

    @IBOutlet weak var categoryPickerView: UIPickerView!

    weak var delegate: NewItemCategoryTableViewCellDelegate?

    var defaultItem = "No category"

    var selectedCategory: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        // setup pickerview
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.selectRow(0, inComponent: 0, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: - PickerView

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Categories.categories.count
    }

    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Categories.categories[row]
    }

    // Get the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = row
        self.delegate?.newItemCategoryTableViewCellInteraptionBegun(sender: self)
    }

}
