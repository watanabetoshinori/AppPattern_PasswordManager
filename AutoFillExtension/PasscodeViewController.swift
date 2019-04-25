//
//  PasscodeViewController.swift
//  AutoFillExtension
//
//  Created by Watanabe Toshinori on 4/25/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

protocol PasscodeViewControllerDelegate: class {

    func passcodeViewControllerDidCanceled()

}

class PasscodeViewController: UIViewController, PasscodeFieldDelegate {
    
    @IBOutlet weak var passcodeField: PasscodeField!
    
    @IBOutlet weak var errorView: UIView!
    
    weak var delegate: PasscodeViewControllerDelegate?
    
    // MARK: - Instantiate ViewController
    
    public class func instantiate(delegate: PasscodeViewControllerDelegate) -> UINavigationController {
        guard let navigationController = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "PasscodeNavigationController") as? UINavigationController,
            let viewController = navigationController.topViewController as? PasscodeViewController else {
            fatalError("Invalid storyboard")
        }
        
        viewController.delegate = delegate
        
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
    
    // MARK: - Action
    
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.passcodeViewControllerDidCanceled()
    }
    
}
