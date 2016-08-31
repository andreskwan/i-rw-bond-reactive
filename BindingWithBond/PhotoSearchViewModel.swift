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

    private let searchService: PhotoSearch = {
        let apiKey = NSBundle.mainBundle().objectForInfoDictionaryKey("apiKey") as! String
        return PhotoSearch(key: apiKey)
    }()
    
    init() {
        searchString.value = "Bond"
        
        /*
         Test - bidirectionalBindTo
         */
        searchString.observeNew {
            text in
            print(text)
        }
        /*
         Validation: text longitud
         */
        searchString.map{ $0!.characters.count > 3 }
                    .bindTo(validSearchText)
        
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
    
    func executeSearch(text: String) {
        print(text)
        var query = PhotoQuery()
        query.text = searchString.value ?? " "
        
        searchService.findPhotos(query) { result in
            switch result {
            case .Success(let photos):
                    print("500px API returned \(photos.count) photos")
            case .Error:
                print("Sad face :(")
            }
        }
    }
}

private extension PhotoSearchViewModel {
    
}
