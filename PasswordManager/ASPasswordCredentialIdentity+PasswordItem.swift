//
//  ASPasswordCredentialIdentity+PasswordItem.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/25/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices

extension ASPasswordCredentialIdentity {
    
    convenience init(_ passwordItem: PasswordItem) {
        let serviceIdentifier = ASCredentialServiceIdentifier(identifier: passwordItem.website,
                                                              type: .domain)
        self.init(serviceIdentifier: serviceIdentifier,
                  user: passwordItem.user,
                  recordIdentifier: passwordItem.id)
    }
    
}
