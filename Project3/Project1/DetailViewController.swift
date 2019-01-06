//
//  DetailViewController.swift
//  Project1
//
//  Created by Tanner Quesenberry on 1/3/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped(){
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return navigationController?.hidesBarsOnTap ?? false
    }
    
}
