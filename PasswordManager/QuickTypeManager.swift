//
//  QuickTypeManager.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/25/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices

class QuickTypeManager: NSObject {
    
    private var observer: Any?
    
    private var isEnabled = false
    
    // MARK: - Initializing a Singleton
    
    static let shared = QuickTypeManager()
    
    override private init() {

    }
    
    // MARK: - Start observing store state

    func activate() {
        updateState()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in
            self.updateState()
        }
    }
    
    func updateState(_ completionHandler: ((Bool) -> Void)? = nil) {
        ASCredentialIdentityStore.shared.getState({ (state) in
            self.isEnabled = state.isEnabled
            
            if self.isEnabled == false {
                return
            }
            
            var passwordItems = PasswordItem.all()
            
            if state.supportsIncrementalUpdates, let lastSyncDate = UserDefaults.forAppGroup.lastSyncDate {
                passwordItems = passwordItems.filter("date >= %@", lastSyncDate)
            }
            
            if passwordItems.count == 0 {
                DispatchQueue.main.async {
                    completionHandler?(true)
                }
                return
            }
            
            let credentialIdentifiers = Array(passwordItems).map({ ASPasswordCredentialIdentity($0) })
            
            ASCredentialIdentityStore.shared.saveCredentialIdentities(credentialIdentifiers, completion: { (success, error) in
                if let error = error {
                    print(error)
                    
                    DispatchQueue.main.async {
                        completionHandler?(false)
                    }

                    return
                }
                
                DispatchQueue.main.async {
                    UserDefaults.forAppGroup.lastSyncDate = Date()

                    completionHandler?(true)
                }
            })
        })
    }
    
    // MARK: - Managing QuicType Sugestion Items
    
    func save(_ credentialIdentity: ASPasswordCredentialIdentity) {
        if isEnabled == false {
            return
        }

        ASCredentialIdentityStore.shared.saveCredentialIdentities([credentialIdentity]) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }

    func remove(_ credentialIdentity: ASPasswordCredentialIdentity) {
        if isEnabled == false {
            return
        }
        
        ASCredentialIdentityStore.shared.removeCredentialIdentities([credentialIdentity]) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }

    func remove(_ credentialIdentities: [ASPasswordCredentialIdentity]) {
        if isEnabled == false {
            return
        }

        ASCredentialIdentityStore.shared.removeCredentialIdentities(credentialIdentities) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }

}
