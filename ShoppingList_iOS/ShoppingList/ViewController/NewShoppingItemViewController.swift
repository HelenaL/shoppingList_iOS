//
//  NewShoppingItemViewController.swift
//  ShoppingList
//
//  Created by Lenochka on 8/27/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit
import CoreData

class NewShoppingItemViewController: UITableViewController, UINavigationControllerDelegate {

    // MARK: - Properties

    var dataController: DataController!
    var shoppingList: ShoppingList!
    var editingShoppingItem: ShoppingItem?

    @IBOutlet weak var nameCell: NewItemNameTableViewCell!
    @IBOutlet weak var detailsCell: NewItemDetailsTableViewCell!
    @IBOutlet weak var categoryCell: NewItemCategoryTableViewCell!
    @IBOutlet weak var photoCell: NewItemPhotoTableViewCell!

    @IBOutlet weak var saveButton: UIBarButtonItem!

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false

        nameCell.delegate = self
        categoryCell.delegate = self

        if let editingShoppingItem = editingShoppingItem {
            setEditingItem(itemToEdit: editingShoppingItem)
        }
    }

    func setEditingItem(itemToEdit: ShoppingItem!) {
        saveButton.isEnabled = true

        nameCell.nameTextField.text = itemToEdit.name

        if let detailsText = itemToEdit.details {
            detailsCell.detailsTextView.text = detailsText
        }

        categoryCell.categoryPickerView.selectRow(Int(itemToEdit.category), inComponent: 0, animated: true)

        if let data = itemToEdit.image, let image = UIImage(data: data) {
            photoCell.photoImageView.image = image
         }
    }

    // MARK: - Editing

    // add new shopping item
    func addNewShoppingItem(name: String, details: String?, category: Int, image: UIImage?) {

        let item = ShoppingItem(context: dataController.viewContext)
        item.name = name
        item.isBought = false
        item.details = details
        item.category = Int32(category)
        item.createdAt = Date()
        item.image = image?.pngData()

        shoppingList.addToShoppingItems(item)

        try? dataController.viewContext.save()
    }

    func saveShoppingItem(shoppingItem: ShoppingItem, name: String, details: String?, category: Int, image: UIImage?) {
        shoppingItem.name = name
        shoppingItem.isBought = false
        shoppingItem.details = details
        shoppingItem.category = Int32(category)
        shoppingItem.image = image?.pngData()

         try? dataController.viewContext.save()
    }

    // MARK: - Actions

    @IBAction func saveButtonAction(_ sender: Any) {
        if let nameText = nameCell.nameTextField.text {
            if let editingShoppingItem = editingShoppingItem {
                saveShoppingItem(shoppingItem: editingShoppingItem, name: nameText,
                                 details: detailsCell.detailsTextView.text,
                                 category: categoryCell.selectedCategory,
                                 image: photoCell.photoImageView.image)
            } else {
                addNewShoppingItem(name: nameText,
                                   details: detailsCell.detailsTextView.text,
                                   category: categoryCell.selectedCategory,
                                   image: photoCell.photoImageView.image)
            }
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonAction(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 3 {
            resignTextViewsresponders()
            openPhotoPickerAlert()
        }
    }

    // MARK: - Helpers

    func showIndicators(isLoading: Bool) {
        // show indicator of loading
        if isLoading {
            photoCell.indicator.startAnimating()
            saveButton.isEnabled = false
        } else {
            photoCell.indicator.stopAnimating()
            saveButton.isEnabled = true
        }
    }

    func resignTextViewsresponders() {
        nameCell.nameTextField.resignFirstResponder()
        detailsCell.detailsTextView.resignFirstResponder()
    }
}

extension NewShoppingItemViewController: NewItemCategoryTableViewCellDelegate {
    func newItemCategoryTableViewCellInteraptionBegun(sender: Any) {
        resignTextViewsresponders()
    }
}

extension NewShoppingItemViewController: NewItemNameTableViewCellDelegate {
    func newItemNameTableViewCell(sender: Any, didChangeText text: String?) {
        let aText = text ?? ""
        saveButton.isEnabled = !aText.isEmpty
    }
}

extension NewShoppingItemViewController: UIImagePickerControllerDelegate {

    func openPhotoPickerAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Alert_image_title", comment: ""), message: nil, preferredStyle: .actionSheet)

        let actionLibrary = UIAlertAction(title: NSLocalizedString("Alert_image_library", comment: ""), style: .default) { _ in
            // open photo library
            self.openImagePicker(.photoLibrary)
        }
        alert.addAction(actionLibrary)

        // check if the camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let actionCamera = UIAlertAction(title: NSLocalizedString("Alert_image_camera", comment: ""), style: .default) { _ in
                // open camera
                self.openImagePicker(.camera)
            }
            alert.addAction(actionCamera)
        }

        if photoCell.photoImageView.image != nil {
            let actionClearImage = UIAlertAction(title: NSLocalizedString("Alert_image_delete", comment: ""), style: .default) { _ in
                // clear Image view
                self.clearPhotoView()
            }
            alert.addAction(actionClearImage)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Alert_cancel", comment: ""), style: .cancel) { _ in
            // It will dismiss action sheet
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func openImagePicker(_ type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }

    func clearPhotoView () {
        photoCell.photoImageView.image = nil
    }

    // MARK: - ImagePickerControllerDelegate methods

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // get chosen image from imagePickerController
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoCell.photoImageView.image = image
            photoCell.photoImageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }

}
