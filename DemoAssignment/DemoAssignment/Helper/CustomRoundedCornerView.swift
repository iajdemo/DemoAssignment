//
//  CustomRoundedCornerView.swift
//  DemoAssignment
//
//  Created by IA on 09/09/24.
//

import UIKit

class CustomRoundedCornerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.cornerRadius = CornerRadius.large
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
