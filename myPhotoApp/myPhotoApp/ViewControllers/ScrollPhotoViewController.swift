//
//  ScrollPhotoViewController.swift
//  myPhotoApp
//
//  Created by NIKITA NIKOLICH on 23.03.2022.
//

import UIKit

class ScrollPhotoViewController: UIViewController {
    
    var array: [UIImageView] = []
    
    private let photosScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

}


//MARK: - Extension

private extension ScrollPhotoViewController {
    
    func setupView() {
        view.backgroundColor = .white
        setConstraint()
        generateImageViews()
    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout(photosScrollView)
        photosScrollView.addSubview(contentView)
        photosScrollView.bindSubviewsToBoundsView(contentView)
        
        NSLayoutConstraint.activate([
            photosScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.heightAnchor.constraint(equalTo: photosScrollView.heightAnchor),
        ])
    }
    
    func generateImageViews() {
        var previousViewAnchor = contentView.leadingAnchor
        
        
        for imageView in array {
            imageView.contentMode = .scaleAspectFit
            contentView.addSubviewsForAutoLayout(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: previousViewAnchor),
                imageView.widthAnchor.constraint(equalTo: photosScrollView.widthAnchor)
            ])
            previousViewAnchor = imageView.trailingAnchor
        }

        if let lastImageView = contentView.subviews.last {
            NSLayoutConstraint.activate([
                lastImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
        
    }
}
