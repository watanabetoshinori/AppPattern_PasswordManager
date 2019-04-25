//
//  AddPasswordViewController.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/23/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices

class AddPasswordViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var websiteField: UITextField!
    
    @IBOutlet weak var userField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        websiteField.textColor = view.tintColor
        userField.textColor = view.tintColor
        passwordField.textColor = view.tintColor
        
        websiteField.becomeFirstResponder()
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == websiteField {
            userField.becomeFirstResponder()
        } else if textField == userField {
            passwordField.becomeFirstResponder()
        } else {
            if doneButtonItem.isEnabled {
                doneTapped(doneButtonItem as Any)
            }
        }
        
        return true
    }

    // MARK: - Actions

    @IBAction func fieldEditingChanged(_ sender: Any) {
        doneButtonItem.isEnabled = websiteField.text?.isEmpty == false
            && parseDomain(from: websiteField.text!).isEmpty == false
            && userField.text?.isEmpty == false
            && passwordField.text?.isEmpty == false
    }

    @IBAction func doneTapped(_ sender: Any) {
        addPasswordItem(website: parseDomain(from: websiteField.text!),
                        user: userField.text!,
                        password: passwordField.text!)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Verify field value
    
    private func parseDomain(from string: String) -> String {
        // This method performs a simple domain check.
        // If you want to check the domain more strictly, please use the following library
        // https://github.com/Dashlane/SwiftDomainParser
        
        var urlString = string

        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            urlString = "https://" + urlString
        }
        
        return URL(string: urlString)?.host ?? ""
    }
    
    // MARK: - Managing PasswordItem
    
    private func addPasswordItem(website: String, user: String, password: String) {
        let passwordItem = PasswordItem(website: website, user: user, password: password)
        passwordItem.add()
        
        dismiss(animated: true, completion: nil)
    }

}
