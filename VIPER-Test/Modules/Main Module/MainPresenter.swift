//
//  MainPresenter.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

final class MainPresenter: Presenterable {
    
    private weak var view: MainViewInputs!
    private(set) var interactor: MainInteractor
    private(set) var router: MainRouter
    private var entity: MainEntity
    
    init(view: MainViewInputs, interactor: MainInteractor, router: MainRouter, entity: MainEntity) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.entity = entity
    }
}


// MARK: - Main View Outputs
extension MainPresenter: MainViewOutputs {
    
    func viewDidLoad() {
        view.setNavigationTitle(text: "Rick and Morty Characters")
        view.setupCollectionView()
        view.setupRefreshControl()
        startFetching()
    }
    
    func onReachBottom() {
        guard entity.pageCount < entity.maxPage else {
            view.removeActivityIndicator()
            return
        }
        startFetching()
    }
    
    func onRefresh() {
        ImageCacher.shared.imageCache.removeAllObjects()
        entity.characters.removeAll()
        entity.pageCount = 1
        view.resetCollectionViewToOriginal()
        startFetching()
    }
    
    private func startFetching() {
        guard !entity.isFetching else { return }
        entity.isFetching = true
        interactor.fetchCharacters(page: entity.pageCount)
    }
}

// MARK: - Main Interactor Outputs
extension MainPresenter: MainInteractorOutputs {
    
    func onSuccessFetch(result: CharacterFetchResult) {
        entity.isFetching = false
        entity.pageCount += 1
        entity.maxPage = result.info.pages
        entity.characters.append(contentsOf: result.characters)
        view.reloadCollectionView(dataSource: MainCollectionViewDataSource(entity: entity))
    }
    
    func onFailureFetch(error: Error) {
        entity.isFetching = false
    }
}
