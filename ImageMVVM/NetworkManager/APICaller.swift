//
//  APICaller.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 22.02.2025.


import Foundation
import UIKit

enum NetworkError: Error {
    
    case urlError
    case canNotParseData
}

public class APICaller {
    static let shared = APICaller()
    static var cache = NSCache<AnyObject, UIImage>()
    private init() {}
    
    static func getImagesFromServer(completionHandler: @escaping (_ result: Result<[ImageModel], NetworkError>) -> Void) {
        
        if NetworkConstant.shared.photosServerAddress.isEmpty {
            print("<!> API KEY is Missing <!>")
            print("<!> Get One from: https://www.themoviedb.org/ <!>")
            return
        }
        
        let urlString = NetworkConstant.shared.photosServerAddress
        
        guard let url = URL(string: urlString) else {
            completionHandler(Result.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode([ImageModel].self, from: data) {
                completionHandler(.success(resultData))
            } else {
                print(err.debugDescription)
                completionHandler(.failure(.canNotParseData))
            }
        }.resume()
    }
    
    func downloadImage(imgURL: URL, completion: @escaping (UIImage?) -> Void) {
        //print("")
        if let cachedImage = APICaller.cache.object(forKey: imgURL as AnyObject) {
            print("You get image from cache")
            completion(cachedImage)
            
        }else {
            URLSession.shared.dataTask(with: imgURL) { (data, respnse, error) in
                if let error = error {
                    print("Error: \(error)")
                    
                }else if let data = data {
                    
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        
                        if let img = image{
                            APICaller.cache.setObject(img, forKey: imgURL as AnyObject)
                            print("You get image from \(imgURL)")
                            completion(img)
                        }else{
                            completion(nil)
                        }
                    }
                }
            }.resume()
        }
    }
}

