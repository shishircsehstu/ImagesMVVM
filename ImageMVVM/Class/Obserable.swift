//
//  Obserable.swift
//  ImageMVVM
//
//  Created by Md Saddam Hossain on 22.02.2025.
//

import Foundation

class Observable <T> {
    
    init( _ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value) // Notify listener when value changes
            }
        }
    }
    func bind( _ listener: @escaping ((T?) -> Void)) {
        listener(value)
        self.listener = listener  // Immediately call with current value
    }
}

