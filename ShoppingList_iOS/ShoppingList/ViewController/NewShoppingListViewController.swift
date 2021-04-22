//
//  NewShoppingListViewController.swift
//  ShoppingList
//
//  Created by Lenochka on 8/26/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit
import CoreData

class NewShoppingListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Properties

    enum Priority: Int {
        case noPriority = 0
        case low = 1
        case middle = 2
        case high = 3
    }

    var dataController: DataController!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priorityPickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var pickerData = [NSLocalizedString("Priority_No_Priority", comment: ""),
                      NSLocalizedString("Priority_Low_Priority", comment: ""),
                      NSLocalizedString("Priority_Mid_Priority", comment: ""),
                      NSLocalizedString("Priority_High_Priority", comment: "")]
    var defaultItem = "No priority"

    var selectedPriority: Int = 0

    // MARK: - View Controller Lifecycle

    fileprivate func priorityPickerViewSetup() {
        priorityPickerView.delegate = self
        priorityPickerView.dataSource = self
        priorityPickerView.selectRow(0, inComponent: 0, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false

        // setup pickerview
        priorityPickerViewSetup()

        // notification for checking if the textfield text has been changed
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification), name: UITextField.textDidChangeNotification, object: nameTextField)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // show keyboard when VC appeare
        nameTextField.becomeFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Editing

    // add new shopping list
    func addNewshoppingList(name: String, priority: Int) {
        let list = ShoppingList(context: dataController.viewContext)
        list.name = name
        list.priority = Int32(priority)
        list.createdAt = Date()

        try? dataController.viewContext.save()
    }

    // MARK: - Actions

    @IBAction func saveButtonAction(_ sender: Any) {
        if let nameText = nameTextField.text {
            addNewshoppingList(name: nameText, priority: selectedPriority)
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func textDidChangeNotification(_ notif: Notification) {
        let aText = nameTextField.text ?? ""
        saveButton.isEnabled = !aText.isEmpty
    }

    // MARK: - PickerView

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    // Get the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriority = row
    }

}
