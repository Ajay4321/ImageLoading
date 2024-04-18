//
//  ViewController.swift
//  AcharyaPrashant
//
//  Created by Ajay Awasthi on 16/04/24.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var imageList: [ImageResponse] = []
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var errorLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.errorLable.isHidden = true
        self.imageCollection.isHidden = false
        let customCollectionViewCellNib = UINib(nibName: "ImageCollectionCell", bundle: nil)
            imageCollection.register(customCollectionViewCellNib, forCellWithReuseIdentifier: "ImageCollectionCell")
        
        Task{
           await loadData()
        }
        
    }
    
//    func loadData() {
//        ImageService.getAllImages{result in
//            switch result {
//            case let .success(cards):
//                print("\(cards)")
//                self.imageList = cards
//                DispatchQueue.main.async {
//                    self.imageCollection.reloadData()
//                }
//            case let .failure(error):
//                DispatchQueue.main.async {
//                    self.imageCollection.isHidden = true
//                    self.errorLable.isHidden = false
//                    self.errorLable.text = error.localizedDescription
//                }
//            }
//        }
//    }
    
    func loadData() async {
        do {
            let images = try await ImageService.getAllImages()
            self.imageList = images
            self.imageCollection.reloadData()
        } catch {
            self.imageCollection.isHidden = true
            self.errorLable.isHidden = false
            self.errorLable.text = error.localizedDescription
        }
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.imageList.count
        }
        
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
             
             let urString: String = "\(self.imageList[indexPath.item].thumbnail.domain)/\(self.imageList[indexPath.item].thumbnail.basePath)/\(self.imageList[indexPath.item].thumbnail.qualities[2])/\(self.imageList[indexPath.item].thumbnail.key)"
             let imageUrl = URL(string: urString)!

                cell.imgView.image = nil
                cell.loadImage(from: imageUrl)

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


