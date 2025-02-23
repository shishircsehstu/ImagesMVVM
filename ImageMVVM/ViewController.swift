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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.getData()
    }
    
    func bindViewModel() {
        
        /*
         viewModel.movies.bind { [weak self] movies in
         guard let self = self,
         let movies = movies else {
         return
         }
         movieDataSource = movies
         movieTableView.reloadData()
         }
         */
        viewModel.dataModel.bind { [weak self] dataModel in
            guard let self = self, let imageDataModel = dataModel else {return}
            self.dataModel = imageDataModel
            print(dataModel)
        }
    }
    
}

