//
//  DiscoveryViewModel.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 31/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

protocol DiscoveryViewModelDelegate: class {
    func reloadDropDownDataSource(searches:[String])
    func reloadCollectionView()
}

class DiscoveryViewModel {
    
    var photos: PhotoCollection?
    var recentSearches = RecentSearches()
    let listingManager = PhotoListingsService()
    weak var delegate: DiscoveryViewModelDelegate?
    
    init() {

    }
    
    func fetchPhotos(searchText: String) {
        //TODO : Perfomance improvements
        photos = PhotoCollection.init(searchText: searchText)
        photos!.delegate = self
        photos!.fetch()
    }
    
    func fetchRecentSearches() -> [String]{
        if (recentSearches.isRecentSearchesAvailable) {
            return recentSearches.searches
        }
        return []
    }
    
    func appendRecentSearch(_ searchText: String) {
        recentSearches.add(searchText)
        delegate?.reloadDropDownDataSource(searches: recentSearches.searches)
    }
}

extension DiscoveryViewModel: PhotoCollectionDelegate {
    func fetchCompleted() {
        delegate?.reloadCollectionView()
    }
}
