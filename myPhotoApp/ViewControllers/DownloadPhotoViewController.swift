//
//  DownloadPhotoViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 22.03.2022.
//

import UIKit

class DownloadPhotoViewController: UIViewController {
    
    let manager = LocalFileManager.instance
    var identifiersArray: [String] = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
    var bottomButtonConstraint: NSLayoutConstraint?
    
    private let customButtonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let commentTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("сommentary", comment: "")
        return textField
    }()
    
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo.artframe")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        image.layer.cornerRadius = 10
        image.backgroundColor = .systemBlue
        return image
    }()
    
    private lazy var newPhotoWithCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(newPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var downloadPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(downloadPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("back", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
        addKeyboardObserver()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(recognizer)
        print(identifiersArray.count)
    }
    
    
    @objc func saveImage() {
        let identifier = UUID()
        identifiersArray.append("\(identifier)")
        UserDefaults.standard.set(self.identifiersArray, forKey: "keyList")
        print(identifiersArray.count)
        manager.save(image: photoImageView.image, name: "\(identifier)", comment: commentTextFiled.text ?? "")
        showAlertDone()
        doneButton.backgroundColor = .darkGray
        doneButton.isEnabled = false
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        bottomButtonConstraint?.constant -= (keyboardFrame.height - 20)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            self.bottomButtonConstraint?.constant = -5 - keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        bottomButtonConstraint?.constant = -80
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func newPhoto() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlertError()
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func downloadPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func showAlertError() {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("errorCameraAlert", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("back", comment: ""), style: .destructive, handler: nil))
        present(alert, animated: true)
    }
    
    func showAlertDone() {
        let alert = UIAlertController(title: NSLocalizedString("congratulations", comment: ""), message: NSLocalizedString("addPhotoAllert", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { UIAlertAction in
            self.photoImageView.contentMode = .scaleAspectFit
            self.photoImageView.image = UIImage(systemName: "photo.artframe")
            self.commentTextFiled.text = ""
        } ))
        present(alert, animated: true)
    }
    

}

//MARK: - Extension

private extension DownloadPhotoViewController {
    
    func setupView() {
        
        title = NSLocalizedString("image", comment: "")
        view.backgroundColor = .white

    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([customButtonsView, photoImageView, commentTextFiled, doneButton, backButton])
        customButtonsView.addSubviewsForAutoLayout([newPhotoWithCameraButton, downloadPhotoButton])
        
        bottomButtonConstraint = backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        bottomButtonConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            
            photoImageView.bottomAnchor.constraint(equalTo: commentTextFiled.topAnchor, constant: -20),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            commentTextFiled.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20),
            commentTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            commentTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            commentTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            doneButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 120),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 120),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            customButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            customButtonsView.widthAnchor.constraint(equalToConstant: 100),
            customButtonsView.heightAnchor.constraint(equalToConstant: 40),
            
            newPhotoWithCameraButton.leadingAnchor.constraint(equalTo: customButtonsView.leadingAnchor),
            newPhotoWithCameraButton.widthAnchor.constraint(equalToConstant: 50),
            newPhotoWithCameraButton.heightAnchor.constraint(equalToConstant: 40),
            
            downloadPhotoButton.trailingAnchor.constraint(equalTo: customButtonsView.trailingAnchor),
            downloadPhotoButton.widthAnchor.constraint(equalToConstant: 50),
            downloadPhotoButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
}

extension DownloadPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
        photoImageView.contentMode = .scaleToFill
        photoImageView.image = image
        
        if photoImageView.image != UIImage(systemName: "photo.artframe") {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .systemBlue
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - Keyboard

extension DownloadPhotoViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    }
}

extension DownloadPhotoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObserver()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
