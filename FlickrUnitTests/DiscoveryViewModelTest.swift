//
//  DiscoveryViewModelTest.swift
//  FlickrTests
//
//  Created by Imayaselvan Ramakrishnan on 01/02/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import XCTest
@testable import Flickr


class DiscoveryViewModelTest: XCTestCase {

    
    func testFetchPhotos() {
        let viewModel = DiscoveryViewModel()
        viewModel.fetchPhotos(searchText: "test")
        XCTAssertEqual(viewModel.photos?.searchText, "test")
        
    }
    
    
    func testRecentSearch() {
        let viewModel = DiscoveryViewModel()
        viewModel.appendRecentSearch("1")
        XCTAssertEqual(viewModel.fetchRecentSearches().first, "1")
    }

}
