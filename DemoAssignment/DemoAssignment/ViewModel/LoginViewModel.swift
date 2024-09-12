//
//  LoginViewModel.swift
//  DemoAssignment
//
//  Created by IA on 09/09/24.
//

import Foundation

final class LoginViewModel {
    
    private let validationHelper = ValidationHelper()
    
    func validateLogin(email: String?, pwd: String?, host: String?) -> ValidationType {
        validationHelper.validateLogin(email: email, pwd: pwd, host: host)
    }
}
