//
//  Realm+AppGroup.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/23/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import RealmSwift

extension Realm {
    
    class func forAppGroup() throws -> Realm {
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
            .appendingPathComponent("Library/Caches/default.realm")
        
        let configuration = Realm.Configuration(fileURL: fileURL)
        
        return try Realm(configuration: configuration)
    }
    
}
