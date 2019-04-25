//
//  CredentialProviderViewController.swift
//  AutoFillExtension
//
//  Created by Watanabe Toshinori on 4/23/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import AuthenticationServices
import RealmSwift

class CredentialProviderViewController: ASCredentialProviderViewController, UITableViewDataSource, UITableViewDelegate, PasscodeViewControllerDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var configurationHeaderView: UIView!
    
    @IBOutlet var configurationStatusLabel: UILabel!
    
    @IBOutlet var cancelButtonItem: UIBarButtonItem!
    
    @IBOutlet var doneButtonItem: UIBarButtonItem!
    
    private var passwordItems: Results<PasswordItem>!

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.topItem?.leftBarButtonItem = nil
        navigationBar.topItem?.rightBarButtonItem = nil
        
        tableView.tableHeaderView = nil
    }
    
    // MARK: - Credential provider methods

    /*
     Prepare your UI to list available credentials for the user to choose from. The items in
     'serviceIdentifiers' describe the service the user is logging in to, so your extension can
     prioritize the most relevant credentials in the list.
    */
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        navigationBar.topItem?.leftBarButtonItem = cancelButtonItem

        // Load password items
        if serviceIdentifiers.count == 1 {
            passwordItems = PasswordItem.all().filter("website like %@", serviceIdentifiers.first!.domainForFilter)
        } else {
            passwordItems = PasswordItem.all()
        }

        tableView.reloadData()

        // Check Passcode lock
        showPasscodeScreenIfLocked()
    }

    /*
     Implement this method if your extension supports showing credentials in the QuickType bar.
     When the user selects a credential from your app, this method will be called with the
     ASPasswordCredentialIdentity your app has previously saved to the ASCredentialIdentityStore.
     Provide the password by completing the extension request with the associated ASPasswordCredential.
     If using the credential would require showing custom UI for authenticating the user, cancel
     the request with error code ASExtensionError.userInteractionRequired.
    */
    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        if UserDefaults.forAppGroup.isLocked {
            // Passcode lock enabled
            extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code:ASExtensionError.userInteractionRequired.rawValue))
            return
        }
        
        guard let id = credentialIdentity.recordIdentifier, let passwordItem = PasswordItem.find(by: id) else {
            // PasswordItem not found
            extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code:ASExtensionError.credentialIdentityNotFound.rawValue))
            return
        }

        let passwordCredential = ASPasswordCredential(passwordItem)
        extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }

    /*
     Implement this method if provideCredentialWithoutUserInteraction(for:) can fail with
     ASExtensionError.userInteractionRequired. In this case, the system may present your extension's
     UI and call this method. Show appropriate UI for authenticating the user then provide the password
     by completing the extension request with the associated ASPasswordCredential.
     */
    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
        navigationBar.topItem?.leftBarButtonItem = cancelButtonItem

        // Load password items
        if let id = credentialIdentity.recordIdentifier {
            passwordItems = PasswordItem.all().filter("id = %@", id)
        } else {
            passwordItems = PasswordItem.all().filter("website like %@", credentialIdentity.serviceIdentifier.domainForFilter)
        }

        tableView.reloadData()

        // Check Passcode lock
        showPasscodeScreenIfLocked()
    }
 
    /*
     Prepare your UI for Settings.
     */
    override func prepareInterfaceForExtensionConfiguration() {
        navigationBar.topItem?.rightBarButtonItem = doneButtonItem

        tableView.tableHeaderView = configurationHeaderView

        // Update QuickType data
        configurationStatusLabel.text = "Updating QuickType..."

        QuickTypeManager.shared.updateState { (success) in
            if success {
                self.configurationStatusLabel.text = "QuickType updated successfully."
            } else {
                self.configurationStatusLabel.text = "QuickType updated failed."
            }
        }
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let passwordItems = passwordItems else {
            return 0
        }
        return passwordItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let passwordItem = passwordItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.layer.cornerRadius = 6
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.image = passwordItem.image
        cell.textLabel?.text = passwordItem.website + " - " + passwordItem.user
        cell.detailTextLabel?.text = passwordItem.website
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let passwordItem = passwordItems[indexPath.row]
        extensionContext.completeRequest(withSelectedCredential: ASPasswordCredential(passwordItem), completionHandler: nil)
    }
    
    // MARK: - Passcode view controller delegate
    
    func passcodeViewControllerDidCanceled() {
        let error = NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue)
        extensionContext.cancelRequest(withError: error)
    }

    // MARK: - Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        extensionContext.completeExtensionConfigurationRequest()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let error = NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue)
        extensionContext.cancelRequest(withError: error)
    }
    
    // MARK: - Show Passcode Lock screen
    
    private func showPasscodeScreenIfLocked() {
        guard UserDefaults.forAppGroup.isLocked else {
            return
        }

        let passcodeNavigationController = PasscodeViewController.instantiate(delegate: self)
        present(passcodeNavigationController, animated: true, completion: nil)
    }

}
