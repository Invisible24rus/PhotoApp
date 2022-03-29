//
//  RegisterViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 23.03.2022.
//

import UIKit
import Foundation
import Security

class RegisterViewController: UIViewController {
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.
        textField.placeholder = NSLocalizedString("enterYourName", comment: "")
        return textField
    }()
    
    private let passwordTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("enterYourPassword", comment: "")
        return textField
    }()
    
    private lazy var regesterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("verification", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(regesterDone), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(recognizer)
    }
    
    func register(userName: String, password: String) {
        guard let password = password.data(using: .utf8) else { return }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecValueData as String: password,
        ]
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("Пользователь зарегистрирован")
        } else {
            print("Error")
        }
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    func showAlertSuccess() {
        let alert = UIAlertController(title: NSLocalizedString("congratulations", comment: ""), message: NSLocalizedString("registrationAlert", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }

}

//MARK: - Extension

private extension RegisterViewController {
    
    func setupView() {
        
        title = NSLocalizedString("registration", comment: "")
        view.backgroundColor = .white
        
        
        
    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([userNameTextField, passwordTextFiled, regesterButton])
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextFiled.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10),
            passwordTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            regesterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regesterButton.topAnchor.constraint(equalTo: passwordTextFiled.bottomAnchor, constant: 20),
            regesterButton.widthAnchor.constraint(equalToConstant: 120),
            regesterButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    @objc func regesterDone() {
        register(userName: userNameTextField.text ?? "", password: passwordTextFiled.text ?? "")
        regesterButton.isEnabled = false
        regesterButton.backgroundColor = .darkGray
        showAlertSuccess()
    }
}
