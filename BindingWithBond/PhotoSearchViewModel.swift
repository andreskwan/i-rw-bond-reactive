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
        
        /*
         ‘throttle’ the queries so that at most only one or two are sent per second.
         */
        searchString
            .filter { $0!.characters.count > 3 }
            .throttle(0.5, queue: Queue.Main)
            .observe {
                [unowned self] text in
                self.executeSearch(text!)
        }
    }
}
