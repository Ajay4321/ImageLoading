//
//  ImageCollectionCell.swift
//  AcharyaPrashant
//
//  Created by Ajay Awasthi on 16/04/24.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var imgView: UIImageView!
    let placeholderImage = UIImage(named: "placeholderImage.jpg")
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 4
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.black.cgColor
    }
    
    func loadImage(from url: URL) {
           // Set placeholder image initially
           imgView.image = placeholderImage
           
           // Load image asynchronously
           ImageLoader.shared.loadImage(from: url) { [weak self] image in
               DispatchQueue.main.async {
                   // If image is available, set it in the image view
                   if let image = image {
                       self?.imgView.image = image
                   } else {
                       // If image is not available, keep showing the placeholder image
                       self?.imgView.image = self?.placeholderImage
                   }
               }
           }
       }
    
}
