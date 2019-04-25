//
//  ASPasswordCredential+PasswordItem.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/25/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices

extension ASPasswordCredential {
    
    convenience init(_ passwordItem: PasswordItem) {
        self.init(user: passwordItem.user, password: passwordItem.password)
    }
    
}
