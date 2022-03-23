//
//  ViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 22.03.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let passwordTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите пароль"
        return textField
    }()
    
    private let confirmPasswordTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите пароль для подтверждения"
        return textField
    }()
    
    private let goToGalleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToGallery), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
    }

}

//MARK: - Extension

private extension LoginViewController {
    
    func setupView() {
        
        title = "Добро пожаловать"
        view.backgroundColor = .white
        
        
        
    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([passwordTextFiled, confirmPasswordTextFiled, goToGalleryButton])
        
        NSLayoutConstraint.activate([
            passwordTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            passwordTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            confirmPasswordTextFiled.topAnchor.constraint(equalTo: passwordTextFiled.bottomAnchor, constant: 10),
            confirmPasswordTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmPasswordTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            goToGalleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToGalleryButton.topAnchor.constraint(equalTo: confirmPasswordTextFiled.bottomAnchor, constant: 20),
            goToGalleryButton.widthAnchor.constraint(equalToConstant: 120),
            goToGalleryButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    @objc func goToGallery() {
        let galleryViewController = GalleryViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(galleryViewController, animated: true)
        
    }
}

