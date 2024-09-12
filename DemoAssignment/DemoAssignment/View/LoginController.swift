//
//  LoginController.swift
//  DemoAssignment
//
//  Created by IA on 08/09/24.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - setup variables
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loginViewModel = LoginViewModel()
    private var email: String = ""
    private var pwd: String = ""
    
    //
    // MARK: - create UI
    //
    let loginView: CustomRoundedCornerView = {
        let view = CustomRoundedCornerView()
        view.backgroundColor = ColorConstants.coolBackground
        return view
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.image = UIImage(named: ImageConstants.iconBrandLogoSmall)
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = CornerRadius.large
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = StringConstants.signInAtLogin
        label.font = .systemFont(ofSize: FontSize.extraLarge, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let mainInputView: CustomRoundedCornerView = {
        let view = CustomRoundedCornerView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var emailTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.delegate = self
        tf.placeholder = StringConstants.placeholderEmail
        tf.text = email
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        return tf
    }()
    
    lazy var pwdTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.delegate = self
        tf.placeholder = StringConstants.placeholderPWD
        tf.text = pwd
        tf.returnKeyType = .next
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var hostTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.delegate = self
        tf.placeholder = StringConstants.placeholderHost
        tf.text = host
        tf.returnKeyType = .done
        return tf
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorConstants.primaryDark
        button.setTitle(StringConstants.signIn, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: FontSize.large, weight: .medium)
        button.layer.cornerRadius = CornerRadius.medium
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        return button
    }()
    
    //
    // MARK: - viewDidLoad
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //
    // MARK: - handle sign in
    //
    @objc func handleSignInButton(_ sender: UIButton) {
        let type = loginViewModel.validateLogin(email: emailTextField.text, pwd: pwdTextField.text, host: hostTextField.text)
        if type == ValidationType.success {
            getToken()
        } else {
            showAlert(title: StringConstants.alert, message: type.rawValue)
        }
    }
    
    func getToken() {
        Task {
            do {
                startLoading()
                let email = emailTextField.text ?? ""
                let pwd = pwdTextField.text ?? ""
                host = hostTextField.text ?? ""
                let channelsListViewModel = ChannelsListViewModel()
                if let unwrappedResult = try await channelsListViewModel.getChannelsList(email: email, pwd: pwd),
                   !unwrappedResult.isEmpty {
                    //                    print(unwrappedResult)
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.setIsLoggedIn()
                        self.navigateToChannelsListController(result: unwrappedResult)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.showAlert(title: StringConstants.noDataFound, message: StringConstants.pleaseRetryLater)
                    }
                }
            } catch let serviceError {
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.showAlert(title: StringConstants.somethingWentWrong, message: serviceError.localizedDescription)
                }
                throw serviceError
            }
        }
    }
    
    func setIsLoggedIn() {
        userDefaults.set(true, forKey: "isLoggedIn")
        userDefaults.synchronize()
    }
    
    func navigateToChannelsListController(result: [Channels]) {
        let channelsListController = ChannelsListController()
        channelsListController.channelsListArray = result
        navigationController?.pushViewController(channelsListController, animated: true)
    }
}
//
// MARK: - UITextFieldDelegate methods
//
extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            pwdTextField.becomeFirstResponder()
        } else if textField == pwdTextField {
            hostTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
}
//
// MARK: - handle loading
//
extension LoginController {
    
    func startLoading() {
        activityIndicator.startAnimating(in: view)
        view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        activityIndicator.stopAnimatingIndicator()
        view.isUserInteractionEnabled = true
    }
}
//
// MARK: - setupUI
//
extension LoginController {
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(loginView)
        loginView.addSubview(logoImageView)
        loginView.addSubview(titleLabel)
        loginView.addSubview(mainInputView)
        mainInputView.addSubview(emailTextField)
        mainInputView.addSubview(pwdTextField)
        mainInputView.addSubview(hostTextField)
        loginView.addSubview(signInButton)
        
        // MARK: - setup autoLayout
        loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.viewMarginMedium).isActive = true
        loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.viewMarginMedium).isActive = true
        loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginView.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: Spacing.viewMarginMedium).isActive = true
        
        logoImageView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: loginView.topAnchor, constant: Spacing.viewMarginMedium).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: ViewHeights.roundedViewEqual).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: ViewHeights.roundedViewEqual).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor, constant: Spacing.viewMarginMedium).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor, constant: -Spacing.viewMarginMedium).isActive = true
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Spacing.viewMarginMedium).isActive = true
        
        mainInputView.leadingAnchor.constraint(equalTo: loginView.leadingAnchor, constant: Spacing.viewMarginMedium).isActive = true
        mainInputView.trailingAnchor.constraint(equalTo: loginView.trailingAnchor, constant: -Spacing.viewMarginMedium).isActive = true
        mainInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.viewMarginMedium).isActive = true
        mainInputView.bottomAnchor.constraint(equalTo: hostTextField.bottomAnchor, constant: Spacing.viewMarginMedium).isActive = true
        
        emailTextField.leadingAnchor.constraint(equalTo: mainInputView.leadingAnchor, constant: Spacing.viewMarginSmall).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: mainInputView.trailingAnchor, constant: -Spacing.viewMarginSmall).isActive = true
        emailTextField.topAnchor.constraint(equalTo: mainInputView.topAnchor, constant: Spacing.viewMarginSmall).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: ViewHeights.textFieldHeight).isActive = true
        
        pwdTextField.leadingAnchor.constraint(equalTo: mainInputView.leadingAnchor, constant: Spacing.viewMarginSmall).isActive = true
        pwdTextField.trailingAnchor.constraint(equalTo: mainInputView.trailingAnchor, constant: -Spacing.viewMarginSmall).isActive = true
        pwdTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Spacing.viewMarginSmall).isActive = true
        pwdTextField.heightAnchor.constraint(equalToConstant: ViewHeights.textFieldHeight).isActive = true
        
        hostTextField.leadingAnchor.constraint(equalTo: mainInputView.leadingAnchor, constant: Spacing.viewMarginSmall).isActive = true
        hostTextField.trailingAnchor.constraint(equalTo: mainInputView.trailingAnchor, constant: -Spacing.viewMarginSmall).isActive = true
        hostTextField.topAnchor.constraint(equalTo: pwdTextField.bottomAnchor, constant: Spacing.viewMarginSmall).isActive = true
        hostTextField.heightAnchor.constraint(equalToConstant: ViewHeights.textFieldHeight).isActive = true
        
        signInButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        signInButton.topAnchor.constraint(equalTo: mainInputView.bottomAnchor, constant: Spacing.viewMarginMedium).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: SemiRoundedButtonSize.width).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: SemiRoundedButtonSize.height).isActive = true
    }
}
