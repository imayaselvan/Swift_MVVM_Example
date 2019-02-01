//
//  PhotoCollection.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 30/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import UIKit

protocol PhotoCollectionDelegate: class {
    func fetchCompleted()
}

class PhotoCollection: NSObject {

    var models = [Photo]()
    var searchText: String
    var totalCount: Int = 0
    var page: Int = 1
    var isLoading = false
   
    let listingManager = PhotoListingsService()
    weak var delegate: PhotoCollectionDelegate?
    
    init(searchText: String) {
        self.searchText = searchText
        super.init()
    }
    
    func loadMore() {
        guard page  < totalCount else {
            return
        }
        guard isLoading == false else {
            return
        }

        page = page + 1
        isLoading = true
        fetch()
    }
    
    func fetch() {
        fetchPhotos(searchText: self.searchText, pageNo: page)
    }

    func fetchPhotos(searchText: String, pageNo: Int) {
        listingManager.getPhotosList(key: self.searchText, page: page, success: { (collection) in
            DispatchQueue.main.async {
                self.totalCount = collection.photos.totalPages
                self.append(collection.photos.photos)
            }
            self.isLoading = false

        }) { (err) in
                print(" error: \(err.localizedDescription)")
                return
        }
    }
}


extension PhotoCollection {
    
    var count: Int {
        return models.count
    }
    
    func at(_ index: Int) -> Photo {
        return models[index]
    }
    
    func append(_ models: [Photo]) {
        self.models.append(contentsOf: models)
        delegate?.fetchCompleted()
    }
}
