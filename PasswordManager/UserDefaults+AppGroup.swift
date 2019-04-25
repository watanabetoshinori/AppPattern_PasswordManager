//
//  UserDefaults+AppGroup.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/24/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    var isLocked: Bool {
        get {
            return bool(forKey: "isLocked")
        }
        set {
            set(newValue, forKey: "isLocked")
        }
    }
    
    var lastSyncDate: Date? {
        get {
            return value(forKey: "lastSyncDate") as? Date
        }
        set {
            set(newValue, forKey: "lastSynDate")
        }
    }
    
    class var forAppGroup: UserDefaults {
        return UserDefaults(suiteName: appGroup)!
    }

}
