//
//  ImageCollectionCellViewModel.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 23.02.2025.
//

import Foundation
import UIKit

class ImageCollectionCellViewModel {

    var id: String
    var author: String
    var width: Int
    var height: Int
    var downloadURL: URL?
    var image: UIImage?
    
    init(model: ImageModel) {
        
        self.id = model.id
        self.author = model.author
        self.width = model.width
        self.height = model.height
        self.downloadURL = URL(string: model.downloadURL)
    }
}
