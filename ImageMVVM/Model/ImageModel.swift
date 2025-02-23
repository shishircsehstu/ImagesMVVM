//
//  ImageModel.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 22.02.2025.
//

import Foundation

struct ImageModel: Codable {
    
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadURL: String

    // Coding Keys to map "download_url" → "downloadURL"
    private enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

/*
 "id":"102",
 "author":"Ben Moore",
 "width":4320,
 "height":3240,
 "url":"https://unsplash.com/photos/pJILiyPdrXI",
 "download_url":"https://picsum.photos/id/102/4320/3240"
 */

