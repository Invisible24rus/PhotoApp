//
//  DownloadPhotoViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 22.03.2022.
//

import UIKit

class DownloadPhotoViewController: UIViewController {
    
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
        textField.placeholder = "Комментарий"
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
    
    private let newPhotoWithCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(newPhoto), for: .touchUpInside)
        return button
    }()
    
    private let downloadPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(downloadPhoto), for: .touchUpInside)
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
    }
    
    @objc func saveImage() {
  
    }
    
    @objc func newPhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert()
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
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Камера не доступна", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Назад", style: .destructive, handler: nil))
        present(alert, animated: true)
    }

}

//MARK: - Extension

private extension DownloadPhotoViewController {
    
    func setupView() {
        
        title = "Изображение"
        view.backgroundColor = .white
        
        
    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([customButtonsView, photoImageView, commentTextFiled, doneButton])
        customButtonsView.addSubviewsForAutoLayout([newPhotoWithCameraButton, downloadPhotoButton])
        
        NSLayoutConstraint.activate([
            
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            commentTextFiled.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            commentTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            commentTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            commentTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            doneButton.topAnchor.constraint(equalTo: commentTextFiled.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 120),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            
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
        guard let fileUrl = info[.imageURL] as? URL else { return }
        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
        photoImageView.contentMode = .scaleToFill
        photoImageView.image = image
        print(fileUrl.lastPathComponent)
        picker.dismiss(animated: true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
