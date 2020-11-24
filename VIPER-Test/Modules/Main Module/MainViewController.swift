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
    func refresh()
    func search(with searchText: String)
    func resetSearch()
    func onTapFilter()
    func filterCharacters(with status: Status?)
}

protocol MainViewInputs: AnyObject {
    func reloadCollectionView(dataSource: MainCollectionViewDataSource)
    func removeActivityIndicator()
    func showActivityIndicator()
    func showEmptyMessage()
    func showConnectionError()
    func showUnknownError()
    func emptyCollectionViewData()
    func showFilterAlert()
}


// MARK: - Main View Controller
final class MainViewController: UIViewController {
    
    var presenter: MainViewOutputs?
    var collectionViewDataSource: MainCollectionViewDataSource?
    
    private let footerSize = CGSize(width: 0, height: 60)
    private var collectionViewNeedsRefresh = false
        
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private let errorView = ErrorView()

    private var lastSearchedText = ""
    private var selectedFilterIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        setupRefreshControl()
        presenter?.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshControl.frame = CGRect(x: 0, y: -30, width: refreshControl.bounds.width, height: refreshControl.bounds.height)
    }

    @IBAction func didTapFilter(_ sender: Any) {
        presenter?.onTapFilter()
    }
    
    @objc private func didPullToRefresh() {
        collectionViewNeedsRefresh = true
    }
    
    @objc func didSearch(with searchText: String) {
        presenter?.search(with: searchText)
    }
    
    deinit {
        print("Deinit")
    }
    
    
    // MARK: - Helper Functions
    private func setupSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search for characters"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let characterCellNib = UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
        collectionView.register(characterCellNib, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        
        let footerCellNib = UINib(nibName: "FooterActivityIndicatorCollectionReusableView", bundle: nil)
        collectionView.register(footerCellNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterActivityIndicatorCollectionReusableView.identifier)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (UIScreen.main.bounds.width - 1) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.footerReferenceSize = footerSize
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func layoutErrorView() {
        view.addSubview(self.errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
            presenter?.refresh()
        }
    }
}


// MARK: - Search Bar Delegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(didSearch), object: lastSearchedText)
        lastSearchedText = searchText
        perform(#selector(didSearch), with: searchText, afterDelay: 0.7)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        presenter?.resetSearch()
    }
}


// MARK: - Main View Presenter Inputs
extension MainViewController: MainViewInputs {
    
    func reloadCollectionView(dataSource: MainCollectionViewDataSource) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        
        // Only refresh if current datasource != new fetched datasource
        guard collectionViewDataSource?.characters != dataSource.characters else { return }

        collectionViewDataSource = dataSource
        DispatchQueue.main.async {
            self.errorView.removeFromSuperview()
            self.collectionView.isScrollEnabled = true
            self.collectionView.reloadData()
        }
    }
    
    func removeActivityIndicator() {
        DispatchQueue.main.async {
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.footerReferenceSize = .zero
            }
        }
    }
    
    func showActivityIndicator() {
        collectionViewNeedsRefresh = false
        collectionView.contentInset = .zero
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.footerReferenceSize = footerSize
        }
    }
    
    func showFilterAlert() {
        presentFilterSheet(title: "Filter by status", message: nil, selectedIndex: selectedFilterIndex) { [weak self] (selectedIndex) in
            guard self?.selectedFilterIndex != selectedIndex else { return }
            self?.selectedFilterIndex = selectedIndex
            switch selectedIndex {
            case 0:
                self?.presenter?.filterCharacters(with: nil)
            case 1:
                self?.presenter?.filterCharacters(with: .alive)
            case 2:
                self?.presenter?.filterCharacters(with: .dead)
            case 3:
                self?.presenter?.filterCharacters(with: .unknown)
            default:
                break
            }
        }
    }
    
    func emptyCollectionViewData() {
        collectionViewDataSource?.characters = []
        collectionView.reloadData()
    }
    
    func showEmptyMessage() {
        DispatchQueue.main.async {
            self.errorView.configure(with: "No Results", subtitle: "Try a new search.")
            self.layoutErrorView()
        }
    }
    
    func showConnectionError() {
        DispatchQueue.main.async {
            self.errorView.configure(with: "You're Offline", subtitle: "Turn off Airplane Mode or connect to Wi-Fi")
            self.layoutErrorView()
        }
    }
    
    func showUnknownError() {
        DispatchQueue.main.async {
            self.errorView.configure(with: "Unknown Error", subtitle: "Please try again.")
            self.layoutErrorView()
        }
    }
}


// MARK: - Viewable
extension MainViewController: Viewable, Alertable {}
