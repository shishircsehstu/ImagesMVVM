//
//  MainViewModel.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 22.02.2025.
//

import Foundation

class MainViewModel {
    
    var dataSource: [ImageModel]?
    var dataModel: Observable<[ImageModel]> = Observable(nil)
    var images: Observable<[ImageCollectionCellViewModel]> = Observable(nil)
    
    func getData() {
        
        APICaller.getImagesFromServer { [weak self] result in
            
            switch result {
            case .success(let imageDataModel):
                self?.dataSource = imageDataModel
                self?.mapDataMOdel()
                self?.mapImagesData()
                print("success ",self!.dataSource![0])
                
            case .failure(let errorInfo):
                print(errorInfo)
            }
            self?.parser()
        }
    }
    
    func parser() {
        
    }
    private func mapDataMOdel() {
        dataModel.value =   self.dataSource
    }
    
    private func mapImagesData() {
        let imagesModel = self.dataSource?.compactMap({ImageCollectionCellViewModel(model: $0)})
        images.value = imagesModel
        print(imagesModel)
        
    }
}
