//
//  GaleryViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 22.03.2022.
//

import UIKit

class GalleryViewController: UIViewController {
    
    let manager = LocalFileManager.instance
    
    var identifiersArray: [String] = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
    
    var newPhotoArray: [NewPhoto] = []
    
    private let galleryPhotoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        galleryPhotoCollectionView.dataSource = self
        galleryPhotoCollectionView.delegate = self
        setupView()
        setConstraint()
        fillingArrayPhoto()
        galleryPhotoCollectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        identifiersArray = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
        fillingArrayPhoto()
        galleryPhotoCollectionView.reloadData()
    }
    
    @objc func pressPlusButton() {
        let downloadPhotoViewController = DownloadPhotoViewController()
        downloadPhotoViewController.modalPresentationStyle = .fullScreen
        present(downloadPhotoViewController, animated: true, completion: nil)
    }
    
    func fillingArrayPhoto() {
        newPhotoArray = []
        for identifier in identifiersArray {
            guard let newPhoto = manager.load(name: "\(identifier)") else { return }
            newPhotoArray.append(newPhoto)
        }
    }
    
    @objc func backToRootView() {
        navigationController?.popToRootViewController(animated: true)
    }

}


//MARK: - Extension

private extension GalleryViewController {
    
    func setupView() {
      
        title = NSLocalizedString("gallery", comment: "")
        view.backgroundColor = .white
        
        let addNewPhotoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressPlusButton))
        navigationItem.rightBarButtonItem = addNewPhotoButton
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backToRootView))
        backButton.image = UIImage(systemName: "chevron.backward")
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([galleryPhotoCollectionView])
        
        NSLayoutConstraint.activate([
            galleryPhotoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryPhotoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryPhotoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            galleryPhotoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newPhotoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        let imageData = newPhotoArray[indexPath.row].imageData
        let uiImage = UIImage(data: imageData)
        cell.backgroundView = UIImageView(image: uiImage)
        return cell
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let itemsPerRow = 3
        let itemWidth = (collectionView.frame.width - (layout.minimumLineSpacing * CGFloat(itemsPerRow-1))) / CGFloat(itemsPerRow)
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scrollPhotoViewController = ScrollPhotoViewController()
        scrollPhotoViewController.photoArray = newPhotoArray
        scrollPhotoViewController.indexPathX = IndexPath(item: indexPath.row, section: 0)
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(scrollPhotoViewController, animated: true)
    }
}
