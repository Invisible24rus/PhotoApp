//
//  GaleryViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 22.03.2022.
//

import UIKit

class GalleryViewController: UIViewController {
    
    
    private let imageView1 = UIImageView(image: UIImage(named: "Image1"))
    private let imageView2 = UIImageView(image: UIImage(named: "Image2"))
    private let imageView3 = UIImageView(image: UIImage(named: "Image2"))
    private let imageView4 = UIImageView(image: UIImage(named: "Image2"))
    private let imageView5 = UIImageView(image: UIImage(named: "Image2"))
    lazy var array = [imageView1, imageView2, imageView3, imageView4, imageView5]
    
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
        galleryPhotoCollectionView.reloadData()
    }
    
    @objc func pressPlusButton() {
        let downloadPhotoViewController = DownloadPhotoViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(downloadPhotoViewController, animated: true)
    }

}


//MARK: - Extension

private extension GalleryViewController {
    
    func setupView() {
        
        title = "Галерея"
        view.backgroundColor = .white
        
        let addNewPhotoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressPlusButton))
        navigationItem.rightBarButtonItem = addNewPhotoButton
        
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
        array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        cell.backgroundView = array[indexPath.row]
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
        let image = array[indexPath.row]
        let scrollPhotoViewController = ScrollPhotoViewController()
        scrollPhotoViewController.array = array
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(scrollPhotoViewController, animated: true)
    }
}
