//
//  EditPasswordViewController.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/24/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices

class EditPasswordViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    var passwordItem: PasswordItem!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        updateLeftBarItem(isEditing: isEditing)

        updateFields(isEditing: isEditing)

        userField.text = passwordItem.user
        passwordField.text = passwordItem.password
        websiteLabel.text = passwordItem.website
    }
    
    // MARK: - Managing the Editing of View controller
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        updateLeftBarItem(isEditing: isEditing)

        updateFields(isEditing: editing)

        if editing == false {
            // Done or Cancel tapped
            updatePasswordItemIfNeeded()
            
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Table view datasource
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableView.setEditing(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            passwordItem.delete()
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userField {
            passwordField.becomeFirstResponder()
        } else {
            if navigationItem.rightBarButtonItem?.isEnabled == true {
                setEditing(false, animated: true)
            }
        }
        
        return true
    }

    // MARK: - Update UI
    
    private func updateLeftBarItem(isEditing: Bool) {
        if isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }

    private func updateFields(isEditing: Bool) {
        if isEditing {
            userField.isEnabled = true
            passwordField.isEnabled = true
            userField.textColor = view.tintColor
            passwordField.textColor = view.tintColor
            
        } else {
            userField.isEnabled = false
            passwordField.isEnabled = false
            userField.textColor = .darkGray
            passwordField.textColor = .darkGray
        }
    }
    
    // MARK: - Actions
    
    @IBAction func fieldEditingChanged(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isEnabled = userField.text?.isEmpty == false
            && passwordField.text?.isEmpty == false
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        userField.text = passwordItem.user
        passwordField.text = passwordItem.password

        setEditing(false, animated: true)
    }
    
    // MARK: - Managing PasswordItem
    
    private func updatePasswordItemIfNeeded() {
        let user = userField.text ?? ""
        let password = passwordField.text ?? ""
        
        guard user != passwordItem.user
            || password != passwordItem.password else {
                
            // PasswordItem not changed
            return
        }
        
        passwordItem.update() { item in
            item.user = user
            item.password = password
        }
    }
    
}
