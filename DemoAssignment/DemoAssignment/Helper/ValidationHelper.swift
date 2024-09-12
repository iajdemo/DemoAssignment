//
//  ValidationHelper.swift
//  DemoAssignment
//
//  Created by IA on 09/09/24.
//

import Foundation

enum ValidationType: String {
    case emptyEmail = "Email cannot be empty"
    case invalidEmail = "Please enter valid Email"
    case emptyPWD = "Password cannot be empty"
    case lengthPWD = "Password should be more then 6 characters"
    case emptyHost = "Host cannot be empty"
    case success = "Success"
}

final class ValidationHelper {
    
    func validateEmail(_ email: String?) -> ValidationType {
        guard let email, !email.isEmpty else {
            return .emptyEmail
        }
        
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        let emailFlag = emailPredicate.evaluate(with: email)
        if !emailFlag {
            return .invalidEmail
        }
        
        return .success
    }
    
    func validatePWD(_ password: String?) -> ValidationType {
        guard let password, !password.isEmpty else {
            return .emptyPWD
        }
        
        guard password.count > 6 else {
            return .lengthPWD
        }
        
        return .success
    }
    
    func validateHost(_ host: String?) -> ValidationType {
        guard let host, !host.isEmpty else {
            return .emptyHost
        }
        
        return .success
    }
    
    func validateLogin(email: String?, pwd: String?, host: String?) -> ValidationType {
        let emailType = validateEmail(email)
        let pwdType = validatePWD(pwd)
        let hostType = validateHost(host)
        
        if emailType != .success {
            return emailType
        } else if pwdType != .success {
            return pwdType
        } else if hostType != .success {
            return hostType
        } else {
            return .success
        }
    }
}
