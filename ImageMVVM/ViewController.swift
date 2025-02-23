//
//  ViewController.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain

import UIKit

class ViewController: UIViewController {
    var viewModel: MainViewModel = MainViewModel()
    var dataModel: [ImageModel]?
    let imageCache = NSCache<AnyObject, UIImage>()
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var imageTasks: [IndexPath: URLSessionDataTask] = [:]
    
    var imagesDataSource: [ImageCollectionCellViewModel]? {
        didSet {
            
            if let dataSource = imagesDataSource {
                for i in 0..<dataSource.count {
                    APICaller.shared.downloadImage(imgURL: dataSource[i].downloadURL!) { img in
                        if let img = img {
                            dataSource[i].image = img
                            self.imagesCollectionView.reloadItems(at: [IndexPath(row: i, section: 0)])
                            
                        }
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        print("call fetch data::")
        viewModel.getData()
        loadNIB()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkInternate()
    }
    private func loadNIB() {
        imagesCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.prefetchDataSource = self
        
    }
    
    func bindViewModel() {
        
        
        viewModel.images.bind { [weak self] images in
            guard let self = self,
                  let images = images else {
                return
            }
            imagesDataSource = images
            imagesCollectionView.reloadData()
        }
        
        
        //        viewModel.dataModel.bind { [weak self] dataModel in
        //            guard let self = self, let imageDataModel = dataModel else {return}
        //            self.dataModel = imageDataModel
        //            print(dataModel)
        //            imagesCollectionView.reloadData()
        //        }
    }
    
    private func checkInternate() {
        
        if NetworkMonitor.shared.isInternetAvailable() {
            print("Internet is available")
        } else {
            print("No internet connection")
            // showNoInternetAlert()
            //  return
        }
        
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet", message: "Please check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    /*
    func loadImage(url: URL?, imageView: UIImageView, indexPath: IndexPath) {
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: url as AnyObject) {
            imageView.image = cachedImage
            return
        }
        
        // Download image asynchronously
        guard let url = url else { return }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data), error == nil else { return }
            
            // Cache the image
            self.imageCache.setObject(image, forKey: url as AnyObject)
            
            // Make sure the cell is still displaying this image before setting it
            DispatchQueue.main.async {
                if let visibleCell = self.imagesCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                    visibleCell.imageView.image = image
                }
            }
        }
        
        // Start the image download task
        task.resume()
        
        // Store the task reference to cancel if needed
        imageTasks[indexPath] = task
    }
     */
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesDataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = UIImage(named: "loading")
        
        /*
         cell.imageView.image = UIImage(named: "loading")
         
         imageTasks[indexPath]?.cancel()
         
         // Load the image asynchronously
         //  loadImage(imagesDataSource?[indexPath.row].downloadURL;, imageView: cell.imageView)
         
         
         //loadImage(url: imagesDataSource?[indexPath.row].downloadURL, imageView: cell.imageView)
         loadImage(url: imagesDataSource?[indexPath.row].downloadURL, imageView: cell.imageView, indexPath: indexPath)
         */
        cell.loadCell(imgModel: imagesDataSource?[indexPath.row])
        return cell
    }
    
}


extension ViewController: UICollectionViewDelegate {
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let weidth = imagesCollectionView.frame.size.width / 3 - 4
        
        return CGSize(width: weidth-2, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
}
extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            let imageUrl = imagesDataSource?[indexPath.item].downloadURL
            print("DataSourcePrefetching")
            
            // Prefetch images and store them in cache
            DispatchQueue.global(qos: .background).async { [self] in
                chacheImage(imageUrl: imageUrl)
            }
        }
        
    }
    
    func chacheImage(imageUrl: URL?) {
        
        if let url = imageUrl, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            //  imageCache.setObject(image, forKey: imageUrl?.absoluteString as NSString)
            APICaller.cache.setObject(image, forKey: url as AnyObject)
        }
        
    }
}
