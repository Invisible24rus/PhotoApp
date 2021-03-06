//
//  ViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 22.03.2022.
//

import UIKit
import Foundation
import Security

class LoginViewController: UIViewController {
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("enterYourName", comment: "")
        return textField
    }()
    
    private let passwordTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("enterYourPassword", comment: "")
        return textField
    }()
    
    private lazy var goToGalleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToGallery), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("registration", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(recognizer)
    }
    
    func login(userName: String, password: String, completion: () -> Void) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let pass = String(data: passwordData, encoding: .utf8),
               password == pass {
                print("???????? ????????????????????")
                print(username)
                print(password)
                completion()
            } else {
                showAlertError()
            }
        } else {
            showAlertError()
            print("Error")
        }
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    func showAlertError() {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("errorLoginAlert", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("back", comment: ""), style: .destructive, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func goToGallery() {
        login(userName: userNameTextField.text ?? "", password: passwordTextFiled.text ?? "") {
            let galleryViewController = GalleryViewController()
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(galleryViewController, animated: true)
        }
    }
    
    @objc func goToRegister() {
        let registerViewController = RegisterViewController()
//        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(registerViewController, animated: true)
        
    }

}

//MARK: - Extension

private extension LoginViewController {
    
    func setupView() {
        
        title = NSLocalizedString("welcome", comment: "")
        view.backgroundColor = .white

    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([userNameTextField, passwordTextFiled, goToGalleryButton, goToRegisterButton])
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextFiled.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10),
            passwordTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            goToGalleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToGalleryButton.topAnchor.constraint(equalTo: passwordTextFiled.bottomAnchor, constant: 20),
            goToGalleryButton.widthAnchor.constraint(equalToConstant: 120),
            goToGalleryButton.heightAnchor.constraint(equalToConstant: 40),
            
            goToRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToRegisterButton.topAnchor.constraint(equalTo: goToGalleryButton.bottomAnchor, constant: 20),
            goToRegisterButton.widthAnchor.constraint(equalToConstant: 120),
            goToRegisterButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}

