//
//  DiscoveryViewController.swift
//  Flickr
//
//  Created by Imayaselvan Ramakrishnan on 30/01/19.
//  Copyright © 2019 Imayaselvan Ramakrishnan. All rights reserved.
//

import UIKit

import Kingfisher
import DropDown
import NVActivityIndicatorView

class DiscoveryViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let dropDown = DropDown()
    let viewModel = DiscoveryViewModel()
    var cellsPerRow:CGFloat = 2
    let cellPadding:CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Flickr"
        viewModel.delegate = self
        setupSearchDropDown()
    }
    
    func setupSearchDropDown() {
        dropDown.anchorView = searchBar
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.backgroundColor = .white
        dropDown.direction = .bottom
        dropDown.dataSource = viewModel.fetchRecentSearches()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.fetchPhotosFromViewModel(item)
        }
    }
   
    func fetchPhotosFromViewModel(_ searchText: String) {
        self.viewModel.fetchPhotos(searchText: searchText)
        self.startAnimating()
    }

}

// MARK: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout

extension DiscoveryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.kf.setImage(with: self.viewModel.photos?.models[indexPath.row].imageUrl(), placeholder: UIImage(named: "default-placeholder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoListHeaderView", for: indexPath) as? PhotoListHeaderView {
            sectionHeader.titleLbl.text = "Photos"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = UIScreen.main.bounds.width - (cellPadding + cellPadding * cellsPerRow)
        let size = padding / cellsPerRow
        return CGSize(width: size, height: size)
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView calls this delegate even if contentSize is still zero
        searchBar.resignFirstResponder()
        guard scrollView.contentSize != CGSize.zero else {
            return
        }
        
        guard let photos = self.viewModel.photos else {
            return
        }
        
        let halfPage = Float(photos.count / 2)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let pageLineSpacing = Float(layout.minimumLineSpacing) * halfPage
        let pageHeight = (halfPage * Float(100) + pageLineSpacing)
        let contentHeight = Float(scrollView.contentSize.height)
        let offsetY = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        
        // did we scroll past second half of the last page, if yes, load more
        if offsetY > contentHeight - pageHeight {
            photos.loadMore()
        }
    }
}

// PhotoCollection Delegate
extension DiscoveryViewController : DiscoveryViewModelDelegate {
    func reloadCollectionView() {
        self.collectionView.reloadData()
        stopAnimating()
    }
    
    func reloadDropDownDataSource(searches: [String]) {
        dropDown.dataSource = searches
    }
}

//Search Bar Delegates
extension DiscoveryViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            dropDown.hide()
            viewModel.appendRecentSearch(searchText)
            fetchPhotosFromViewModel(searchText)
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        dropDown.show()
        return true
    }
 }
