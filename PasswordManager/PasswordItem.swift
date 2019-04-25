//
//  Password.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/23/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AuthenticationServices
import RealmSwift

class PasswordItem: Object {
    
    @objc dynamic var id = UUID().uuidString

    @objc dynamic var website = ""

    @objc dynamic var user = ""

    @objc dynamic var password = ""

    @objc dynamic var date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    var image: UIImage {
        let scale = UIScreen.main.scale
        
        let frame = CGRect(x: 0, y: 0, width: 36 * scale, height: 36 * scale)

        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28 * scale)
        label.text = String(website[website.startIndex]).uppercased()

        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        label.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return UIImage(cgImage: image.cgImage!, scale: scale, orientation: .up)
    }
    
    // MARK: - Initialize PasswordItem
    
    convenience init(website: String, user: String, password: String) {
        self.init()
        self.website = website
        self.user = user
        self.password = password
    }
    
    // MARK: - Finding PasswordItems
    
    static func find(by id: String, in realm: Realm = try! Realm.forAppGroup()) -> PasswordItem? {
        return realm.object(ofType: PasswordItem.self, forPrimaryKey: id)
    }
    
    static func all(in realm: Realm = try! Realm.forAppGroup()) -> Results<PasswordItem> {
        let sortDescriptors = [SortDescriptor(keyPath: "website"),
                               SortDescriptor(keyPath: "user")]
        return realm.objects(PasswordItem.self).sorted(by: sortDescriptors)
    }
    
    // MARK: - Managing PasswordItem
    
    func add(in realm: Realm = try! Realm.forAppGroup()) {
        try! realm.write {
            realm.add(self)
        }

        QuickTypeManager.shared.save(ASPasswordCredentialIdentity(self))
    }
    
    func update(in realm: Realm = try! Realm.forAppGroup(), updateBlock: (PasswordItem) -> Void) {
        QuickTypeManager.shared.remove(ASPasswordCredentialIdentity(self))

        try! realm.write {
            updateBlock(self)
        }
        
        QuickTypeManager.shared.save(ASPasswordCredentialIdentity(self))
    }

    func delete(from realm: Realm = try! Realm.forAppGroup()) {
        QuickTypeManager.shared.remove(ASPasswordCredentialIdentity(self))

        try! realm.write {
            realm.delete(self)
        }
    }
    
    static func delete(_ items: [PasswordItem], from realm: Realm = try! Realm.forAppGroup()) {
        QuickTypeManager.shared.remove(items.map({ ASPasswordCredentialIdentity($0) }))

        try! realm.write {
            realm.delete(items)
        }
    }

}
