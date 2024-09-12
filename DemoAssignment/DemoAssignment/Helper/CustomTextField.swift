//
//  CustomTextField.swift
//  DemoAssignment
//
//  Created by IA on 09/09/24.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        placeholder = nil
        text = nil
        font = .systemFont(ofSize: FontSize.medium)
        autocapitalizationType = .none
        autocorrectionType = .no
        keyboardType = .default
        returnKeyType = .done
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
