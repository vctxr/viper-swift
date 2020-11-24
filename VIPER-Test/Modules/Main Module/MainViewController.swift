//
//  MainViewController.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import UIKit

protocol MainViewOutputs: AnyObject {
    func viewDidLoad()
    func onReachBottom()
    func onRefresh()
}

protocol MainViewInputs: AnyObject {
    func reloadCollectionView(dataSource: MainCollectionViewDataSource)
    func removeActivityIndicator()
    func resetCollectionViewToOriginal()
}


// MARK: - Main View Controller
final class MainViewController: UIViewController {
    
    var presenter: MainViewOutputs?
    var collectionViewDataSource: MainCollectionViewDataSource?
    
    private let footerSize = CGSize(width: 0, height: 60)
    private var collectionViewNeedsRefresh = false
        
    @IBOutlet private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(text: "Rick and Morty Characters")
        setupCollectionView()
        setupRefreshControl()
        presenter?.viewDidLoad()
    }
    
    @objc private func didPullToRefresh() {
        collectionViewNeedsRefresh = true
    }
    
    deinit {
        print("Deinit")
    }
    
    
    // MARK: - Helper Functions
    private func setNavigationTitle(text: String) {
        navigationItem.title = text
    }
    
    private func setupCollectionView() {
        let characterCellNib = UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
        collectionView.register(characterCellNib, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        
        let footerCellNib = UINib(nibName: "FooterActivityIndicatorCollectionReusableView", bundle: nil)
        collectionView.register(footerCellNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterActivityIndicatorCollectionReusableView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 1
            let itemWidth = (UIScreen.main.bounds.width - padding) / 2
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.footerReferenceSize = footerSize
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}


// MARK: - Collection View Delegate and Data Source
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionViewDataSource?.cellForItem(in: collectionView, at: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionViewDataSource?.footerView(in: collectionView, at: indexPath) ?? UICollectionReusableView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > scrollView.contentSize.height - scrollView.frame.height {
            presenter?.onReachBottom()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if collectionViewNeedsRefresh {
            presenter?.onRefresh()
        }
    }
}


// MARK: - Main View Presenter Inputs
extension MainViewController: MainViewInputs {
    
    func reloadCollectionView(dataSource: MainCollectionViewDataSource) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        
        // Only refresh if current datasource != new fetched datasource
        guard collectionViewDataSource?.entity.characters != dataSource.entity.characters else { return }

        collectionViewDataSource = dataSource
        DispatchQueue.main.async {
            self.collectionView.isScrollEnabled = true
            self.collectionView.reloadData()
        }
    }
    
    func removeActivityIndicator() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.footerReferenceSize = .zero
        }
    }
    
    func resetCollectionViewToOriginal() {
        collectionViewNeedsRefresh = false
        collectionView.contentInset = .zero
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.footerReferenceSize = footerSize
        }
    }
}


// MARK: - Viewable
extension MainViewController: Viewable {}
