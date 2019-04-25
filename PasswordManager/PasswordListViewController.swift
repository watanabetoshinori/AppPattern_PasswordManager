//
//  PasswordListViewController.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/23/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices
import RealmSwift

class PasswordListViewController: UITableViewController {
    
    @IBOutlet var lockButtonItem: UIBarButtonItem!

    @IBOutlet var cancelButtonItem: UIBarButtonItem!

    @IBOutlet var addButtonItem: UIBarButtonItem!

    @IBOutlet var deleteButtonItem: UIBarButtonItem!

    private var passwordItems: Results<PasswordItem>!
    
    private var notificationToken: NotificationToken!
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize UI
        updateBarButtonItem(isEditing: isEditing)
        tableView.allowsMultipleSelectionDuringEditing = true

        // Load password items
        passwordItems = PasswordItem.all()
        notificationToken = passwordItems.observe(updateTableView)
        
        // Add observer
        NotificationCenter.default.addObserver(self, selector: #selector(hidePasscodeScreenIfUnlocked), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showPasscodeScreenIfLocked()
    }
    
    // MARK: - Managing the Editing of View controller
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        updateBarButtonItem(isEditing: editing)

        updateDeleteButtonState()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwordItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let passwordItem = passwordItems[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.layer.cornerRadius = 6
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.image = passwordItem.image
        cell.textLabel?.text = passwordItem.website + " - " + passwordItem.user
        cell.detailTextLabel?.text = passwordItem.website
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        updateBarButtonItemForTableCellSwipe(isEditing: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        updateBarButtonItemForTableCellSwipe(isEditing: false)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let passwordItem = passwordItems[indexPath.row]
            passwordItem.delete()

        default:
            break
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            updateDeleteButtonState()
            return
        }

        // Edit password item
        let passwordItem = passwordItems[indexPath.row]

        let viewController = storyboard?.instantiateViewController(withIdentifier: "EditPasswordViewController") as! EditPasswordViewController
        viewController.passwordItem = passwordItem
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isEditing {
            updateDeleteButtonState()
            return
        }
    }
    
    // MARK: - Update UI state
    
    private func updateBarButtonItem(isEditing: Bool) {
        if isEditing {
            navigationItem.leftBarButtonItems = [deleteButtonItem]
            navigationItem.rightBarButtonItems = [cancelButtonItem]
        } else {
            navigationItem.leftBarButtonItems = [lockButtonItem]
            navigationItem.rightBarButtonItems = [editButtonItem, addButtonItem]
        }
    }
    
    private func updateBarButtonItemForTableCellSwipe(isEditing: Bool) {
        if isEditing {
            navigationItem.leftBarButtonItems = []
            navigationItem.rightBarButtonItems = [cancelButtonItem]
        } else {
            navigationItem.leftBarButtonItems = [lockButtonItem]
            navigationItem.rightBarButtonItems = [editButtonItem, addButtonItem]
        }
    }

    private func updateDeleteButtonState() {
        deleteButtonItem.isEnabled = (tableView.indexPathsForSelectedRows?.count ?? 0) > 0
    }
    
    // MARK: - Updating Table and CredentialStore by Realm notification
    
    private func updateTableView(_ changes: RealmCollectionChange<Results<PasswordItem>>) {
        switch changes {
        case .initial:
            tableView.reloadData()
            
        case .update(_, let deletions, let insertions, let modifications):
            tableView.beginUpdates()
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            tableView.endUpdates()
            
        case .error(let error):
            fatalError("\(error)")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func lockTapped(_ sender: Any) {
        UserDefaults.forAppGroup.isLocked = true

        showPasscodeScreenIfLocked()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        setEditing(false, animated: true)
    }

    @IBAction func deleteTapped(_ sender: Any) {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
            return
        }
        
        let selectedItems = selectedIndexPaths.map({ passwordItems[$0.row] })
        PasswordItem.delete(selectedItems)
        
        setEditing(false, animated: true)
    }
    
    // MARK: - Show / Hide Passcode Lock screen
    
    private func showPasscodeScreenIfLocked() {
        guard UserDefaults.forAppGroup.isLocked else {
            return
        }

        let passcodeNavigationController = PasscodeViewController.instantiate()
        present(passcodeNavigationController, animated: true, completion: nil)
    }
    
    @objc private func hidePasscodeScreenIfUnlocked() {
        guard UserDefaults.forAppGroup.isLocked == false else {
            return
        }

        if let navigationController = presentedViewController as? UINavigationController,
            let _ = navigationController.topViewController as? PasscodeViewController {
            dismiss(animated: true, completion: nil)
        }
    }

}
