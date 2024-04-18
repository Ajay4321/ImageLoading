//
//  ViewController.swift
//  AcharyaPrashant
//
//  Created by Ajay Awasthi on 16/04/24.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    private var viewModel: HomeViewModel!

    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var errorLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Task{
           await loadData()
        }
    }
    
    func setupViewDidLoad(){
        viewModel = HomeViewModel()
        self.errorLable.isHidden = true
        self.imageCollection.isHidden = false
        let customCollectionViewCellNib = UINib(nibName: "ImageCollectionCell", bundle: nil)
            imageCollection.register(customCollectionViewCellNib, forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    func loadData() async {
        viewModel.loadData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.imageCollection.reloadData()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.imageCollection.isHidden = true
                    self.errorLable.isHidden = false
                    self.errorLable.text = error.localizedDescription
                }
            }
        }
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return viewModel.getImageCount()
        }
        
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            
             let imageResult = viewModel.getImage(at: indexPath.item)
             
             guard indexPath.item < viewModel.getImageCount() else {
                     return cell // Return empty cell if index is out of bounds
                 }
            
             if imageResult.thumbnail.qualities.indices.contains(1) {
                 let imageQuality = imageResult.thumbnail.qualities[1]
                 // Use imageQuality safely
                 let urString: String = "\(imageResult.thumbnail.domain)/\(imageResult.thumbnail.basePath)/\(imageQuality)/\(imageResult.thumbnail.key)"
                 if let imageUrl = URL(string: urString) {
                     cell.loadImage(from: imageUrl)
                 } else {
                     print("Invalid URL: \(urString)")
                 }
             } else {
                 print("Index out of bounds for qualities array")
             }

             return cell
        }

}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


