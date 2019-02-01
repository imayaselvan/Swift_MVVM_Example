//
//  PhotoListService.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 30/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import Foundation

class PhotoListingsService: ApiManager {

    func getPhotosList(key:String, page:Int,  success:@escaping (PhotosContainer) -> Void, failure: @escaping (ApiRequestError) -> Void) {
        let request = getUrlRequest(url: Endpoints.Movies.fetch(key, page).url)!
        sendRequest(request: request, success: { (data: PhotosContainer) in
            success(data)
        }) { (err) in
            failure(err)
        }
    }
}

extension String {
    func encodedString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
    }
}
