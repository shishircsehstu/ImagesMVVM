//
//  ImageCollectionViewCell.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 23.02.2025.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var describLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadCell(imgModel: ImageCollectionCellViewModel?) {
        describLbl.text = imgModel?.author
        
        if imgModel?.image == nil {
            imageView.image = UIImage(named: "loading")
        } else {
            imageView.image = imgModel?.image
        }
    }

}
