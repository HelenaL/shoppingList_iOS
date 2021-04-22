//
//  ShoppingListsViewController.swift
//  ShoppingList
//
//  Created by Lenochka on 8/25/20.
//  Copyright © 2020 LEA. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListsViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    @IBOutlet var newListButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!

    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<ShoppingList>!

    // MARK: - View Controller Lifecycle

    fileprivate func setupFetchedResultController() {
        let fetchRequest: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
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
        setupFetchedResultController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupFetchedResultController()

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }

    // MARK: - Actions

    func deleteShoppingList(at indexPath: IndexPath) {
        let listToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(listToDelete)

        try? dataController.viewContext.save()
    }

    func changePriorityShoppingList(at indexPath: IndexPath, priority: Int) {
        let itemToEdit = fetchedResultsController.object(at: indexPath)
        itemToEdit.priority = Int32(priority)

        try? dataController.viewContext.save()
    }

    @IBAction func newListAction(_ sender: Any) {

    }

    // MARK: - Editing

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNewShoppingList",
            let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? NewShoppingListViewController {
            vc.dataController = dataController
        }

        if let vc = segue.destination as? ShoppingItemsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.shoppingList = fetchedResultsController.object(at: indexPath)
                vc.dataController = dataController
            }
        }

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
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aShoppingList = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListTableViewCell", for: indexPath) as! ShoppingListTableViewCell

        // Configure cell
        cell.fill(shoppingList: aShoppingList, boughtCount: aShoppingList.getUnfinishedCount(context: dataController.viewContext))

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: NSLocalizedString("Alert_delete", comment: "")) {  (_, _, completion) in
            self.deleteShoppingList(at: indexPath)
            completion(true)
        }

        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let contextItemHigh = UIContextualAction(style: .normal, title: "!!!") {  (_, _, completion) in
                self.changePriorityShoppingList(at: indexPath, priority: 3)
                completion(true)
           }
           contextItemHigh.backgroundColor = UIColor.redHighPriority()

           let contextItemMed = UIContextualAction(style: .normal, title: "!!") {  (_, _, completion) in
                self.changePriorityShoppingList(at: indexPath, priority: 2)
                completion(true)
           }
           contextItemMed.backgroundColor = UIColor.orangeMiddlePriority()

           let contextItemLow = UIContextualAction(style: .normal, title: "!") {  (_, _, completion) in
                self.changePriorityShoppingList(at: indexPath, priority: 1)
                completion(true)
           }
           contextItemLow.backgroundColor = UIColor.greenMainTheme()

           let contextItemNo = UIContextualAction(style: .normal, title: NSLocalizedString("Priority_No", comment: "")) {  (_, _, completion) in
                self.changePriorityShoppingList(at: indexPath, priority: 0)
                completion(true)
           }

           let swipeActions = UISwipeActionsConfiguration(actions: [contextItemHigh, contextItemMed, contextItemLow, contextItemNo])

           return swipeActions
    }

}

extension ShoppingListsViewController {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
