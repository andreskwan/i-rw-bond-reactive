//
//  PhotoSearchViewModel.swift
//  BindingWithBond
//
//  Created by Andres Kwan on 8/26/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation
import Bond

class PhotoSearchViewModel {
    let searchString = Observable<String?>("")
    let validSearchText = Observable<Bool>(false)
    
    init() {
        searchString.value = "Bond"
        
        searchString.observeNew {
            text in
            print(text)
        }
        
        searchString
            .map { $0!.characters.count > 3 }
            .bindTo(validSearchText)
    }
}
