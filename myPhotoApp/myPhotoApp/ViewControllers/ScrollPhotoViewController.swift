//
//  ScrollPhotoViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 23.03.2022.
//

import UIKit

class ScrollPhotoViewController: UIViewController {
    
    let manager = LocalFileManager.instance
    
    var photoArray: [NewPhoto] = []
    
    private let commentTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = ""
        return textField
    }()

    private let collectionVIew: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.backgroundColor = .white
        collectionVIew.isPagingEnabled = true
        collectionVIew.bounces = false
        collectionVIew.showsHorizontalScrollIndicator = false
        collectionVIew.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        return collectionVIew
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
    }

}


//MARK: - Extension

private extension ScrollPhotoViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        
        
    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([collectionVIew, commentTextFiled])
        
        NSLayoutConstraint.activate([
            
            collectionVIew.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionVIew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionVIew.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionVIew.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            
            commentTextFiled.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            commentTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            commentTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            commentTextFiled.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
}

//MARK: - UICollectionViewDataSource
extension ScrollPhotoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        let imageData = photoArray[indexPath.row].imageData
        let uiImage = UIImage(data: imageData)
        commentTextFiled.text = photoArray[indexPath.row].comment
        cell.backgroundView = UIImageView(image: uiImage)
        return cell
    }
    
   
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ScrollPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let itemsPerRow = 1
        let itemWidth = (collectionView.frame.width - (layout.minimumLineSpacing * CGFloat(itemsPerRow-1))) / CGFloat(itemsPerRow)
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
