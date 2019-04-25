//
//  PasscodeField.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/24/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

protocol PasscodeFieldDelegate: class {
    
    func passcodeFieldDidEntered(_ success: Bool)

}

class PasscodeField: UITextField, UITextFieldDelegate {

    weak var passcodeDelegate: PasscodeFieldDelegate?

    var valueSymbol = "●"

    var nonValueSymbol = "○"
    
    var passcode = "1234"

    var value = "" {
        didSet {
            text = String(repeating: valueSymbol, count: value.count) + String(repeating: nonValueSymbol, count: passcode.count - value.count)
        }
    }
    
    // MARK: - Initializing a View Object
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        initialize()
    }
    
    private func initialize() {
        delegate = self
        borderStyle = .none
        backgroundColor = .clear
        keyboardType = .numberPad
        textAlignment = .center
        
        // Set empty value to invoke didSet block
        value = ""
    }
    
    // MARK: - Disable user interactions
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    // MARK: - Text field delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isBackSpace = (strcmp(string.cString(using: String.Encoding.utf8)!, "\\b") == -92)
        
        if isBackSpace {
            if value.isEmpty == false {
                value.removeLast()
            }
        } else {
            if value.count < passcode.count {
                value += string
            }
        }
        
        if value.count == passcode.count {
            let isSuccess = (self.value == self.passcode)
            DispatchQueue.main.async {
                self.passcodeDelegate?.passcodeFieldDidEntered(isSuccess)
            }
        }

        return false
    }
    
}
