//
//  ShoppingItemsViewController.swift
//  ShoppingList
//
//  Created by Lenochka on 8/27/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit
import CoreData

class ShoppingItemsViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, ShoppingItemTableViewCellDelegate {

    // MARK: - Properties

    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<ShoppingItem>!
    var shoppingList: ShoppingList!

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var buyLabel: UILabel!

    // MARK: - View Controller Lifecycle

    fileprivate func setupFetchedResultController() {
        let fetchRequest: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        let predicate = NSPredicate(format: "shoppingList == %@", shoppingList)
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let boughtSortDescriptor = NSSortDescriptor(key: "isBought", ascending: true)

        fetchRequest.sortDescriptors = [boughtSortDescriptor, sortDescriptor]
        fetchRequest.predicate = predicate

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("the fetch couldn't perform \(error.localizedDescription)")
        }

        tableView.reloadData()

        if let isEmpty = fetchedResultsController.fetchedObjects?.isEmpty {
            showStartLabel(isHidden: !isEmpty)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = shoppingList.name?.capitalized
        setupFetchedResultController()
        renderBottomContext()
    }

    func renderBottomContext() {
        let bought = shoppingList.getUnfinishedCount(context: fetchedResultsController.managedObjectContext)
        let allObjectsCount = fetchedResultsController.fetchedObjects?.count ?? 0
        buyLabel.text = "\(NSLocalizedString("Label_Bottom_Bought_Count", comment: "")) \(bought)/\(allObjectsCount)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // MARK: - Actions

    func deleteShoppingItem(at indexPath: IndexPath) {
        let itemToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(itemToDelete)

        try? dataController.viewContext.save()
    }

    func editShoppingItem(at indexPath: IndexPath) {
        let itemToEdit = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "openEditShoppingItem", sender: itemToEdit)
    }

    // MARK: - ShoppingItemTableViewCellDelegate

    func shoppingItemTableViewCell(cell: ShoppingItemTableViewCell,
                                   didChangeValue value: Bool,
                                   indexPath: IndexPath) {

        let item = fetchedResultsController.object(at: indexPath)
        item.isBought = !value

        try? dataController.viewContext.save()

        setupFetchedResultController()
    }

    // MARK: - Editing

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // MARK: - Helpers

    func showStartLabel(isHidden: Bool) {

        startLabel.isHidden = isHidden

        if isHidden {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none

            startLabel.alpha = 0
            UIView.animate(withDuration: 1.0, animations: {
                self.startLabel.alpha = 1.0
            })
        }
    }

     // MARK: - UITableViewDataSource

    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aShoppingItem = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemTableViewCell", for: indexPath) as! ShoppingItemTableViewCell

        // Configure cell
        cell.fill(shoppingItem: aShoppingItem)
        cell.indexPath = indexPath
        cell.delegate = self

        return cell
    }

      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: NSLocalizedString("Alert_delete", comment: "")) {  (_, _, completion) in
            self.deleteShoppingItem(at: indexPath)
            completion(true)
        }

        let contextItem1 = UIContextualAction(style: .normal, title: NSLocalizedString("Alert_Edit", comment: "")) {  (_, _, completion) in
            self.editShoppingItem(at: indexPath)
            completion(true)
        }

        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem, contextItem1])

        return swipeActions
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNewShoppingItem",
            let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? NewShoppingItemViewController {
            vc.dataController = dataController
            vc.shoppingList = shoppingList
        }

        if segue.identifier == "openEditShoppingItem",
            let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? NewShoppingItemViewController {
            vc.dataController = dataController
            vc.shoppingList = shoppingList
            vc.editingShoppingItem = sender as? ShoppingItem
        }

        if segue.identifier == "openDetailsShoppingItem",
            let vc = segue.destination as? ShoppingItemDetailsViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    vc.selectedShoppingItem = fetchedResultsController.object(at: indexPath)
                    vc.dataController = dataController
            }
        }
    }

}

extension ShoppingItemsViewController {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        renderBottomContext()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        if let isEmpty = controller.fetchedObjects?.isEmpty {
           showStartLabel(isHidden: !isEmpty)
        }

        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }

}
