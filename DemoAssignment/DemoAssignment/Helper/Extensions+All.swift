//
//  Extensions+All.swift
//  DemoAssignment
//
//  Created by IA on 09/09/24.
//

import UIKit
//
// MARK: - extension UIViewController
//
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: StringConstants.ok, style: .default)
        alertController.addAction(ok)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

//
// MARK: - UIActivityIndicatorView
//
extension UIActivityIndicatorView {
    func startAnimating(in view: UIView) {
        if self.superview == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.hidesWhenStopped = true
            view.addSubview(self)
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        self.startAnimating()
    }
    
    func stopAnimatingIndicator() {
        self.stopAnimating()
        self.removeFromSuperview()
    }
}

//
// MARK: - extension URLRequest
//
extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
        print("\n")
    }
}
