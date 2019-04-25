//
//  LockViewController.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/24/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController, PasscodeFieldDelegate {
    
    @IBOutlet weak var passcodeField: PasscodeField!
    
    @IBOutlet weak var errorView: UIView!
    
    // MARK: - Instantiate ViewController
    
    public class func instantiate() -> UINavigationController {
        guard let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasscodeNavigationController") as? UINavigationController else {
            fatalError("Invalid storyboard")
        }
        
        return navigationController
    }
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        errorView.layer.cornerRadius = 8
        errorView.layer.masksToBounds = true
        errorView.isHidden = true
        
        passcodeField.passcodeDelegate = self
        passcodeField.becomeFirstResponder()
    }
    
    // MARK: - Passcode delegate
    
    func passcodeFieldDidEntered(_ success: Bool) {
        if success {
            UserDefaults.forAppGroup.isLocked = false
            dismiss(animated: true, completion: nil)

        } else {
            errorView.isHidden = false
            passcodeField.value = ""
        }
    }

}
