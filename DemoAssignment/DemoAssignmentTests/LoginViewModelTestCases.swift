//
//  LoginViewModelTestCases.swift
//  DemoAssignmentTests
//
//  Created by IA on 09/09/24.
//

import XCTest
@testable import DemoAssignment

final class LoginViewModelTestCases: XCTestCase {
    
    var loginViewModel: LoginViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginViewModel = LoginViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginViewModel = nil
    }
    
    func testInvalidEmail() {
        guard let loginViewModel else {
            XCTFail("View Model cannot be nil")
            return
        }
        
        let type = loginViewModel.validateLogin(email: "", pwd: "", host: "")
        XCTAssertEqual(type, .emptyEmail, "Email is empty")
        XCTAssertEqual(type.rawValue, "Email cannot be empty")
    }
    
    func testInvalidPassword() {
        guard let viewModel = loginViewModel else {
            XCTFail("View Model cannot be nil")
            return
        }
        let type = viewModel.validateLogin(email: "test@gmail.com", pwd: "", host: "")
        XCTAssertEqual(type, .emptyPWD, "Password is empty")
        XCTAssertTrue(type == .emptyPWD, "Password should be empty")
        
        // Length Of Password
        let type1 = viewModel.validateLogin(email: "test@gmail.com", pwd: "1234", host: "")
        XCTAssertEqual(type1, .lengthPWD, "Password should be more then 6 characters")
        XCTAssert(type1 == .lengthPWD) // TRUE
    }
    
    func testLoginSuccess() {
        guard let viewModel = loginViewModel else {
            XCTFail("View Model cannot be nil")
            return
        }
        
        let type = viewModel.validateLogin(email: "test@gmail.com", pwd: "123456789", host: "mofa.onice.io")
        XCTAssertEqual(type, .success, "Login successful")
    }
}
