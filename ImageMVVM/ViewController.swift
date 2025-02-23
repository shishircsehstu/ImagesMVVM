//
//  ViewController.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 21.02.2025.
//

import UIKit

class ViewController: UIViewController {
    var viewModel: MainViewModel = MainViewModel()
    var dataModel: [ImageModel]?
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
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
    
    
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesDataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
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
