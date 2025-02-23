//
//  NetworkConstant.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 22.02.2025.
//

import Foundation

class NetworkConstant {
    
    public static var shared = NetworkConstant()
    
    public var photosServerAddress: String {
        get {
            return "https://picsum.photos/v2/list?page=2&limit=100"
        }
    }
}
