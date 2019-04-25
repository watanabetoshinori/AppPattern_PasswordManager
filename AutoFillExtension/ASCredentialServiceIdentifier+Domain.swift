//
//  ASCredentialServiceIdentifier+Domain.swift
//  AutoFillExtension
//
//  Created by Watanabe Toshinori on 4/25/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices

extension ASCredentialServiceIdentifier {
    
    var domainForFilter: String {
        let host = URL(string: identifier)?.host ?? identifier
        
        let components = host.components(separatedBy: ".")
        switch components.count {
        case 0...1:
            return "*" + host
        default:
            return "*" + components[components.count - 2] + "." + components[components.count - 1]
        }
    }
    
}
