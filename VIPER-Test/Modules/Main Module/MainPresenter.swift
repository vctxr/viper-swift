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
    
    init(view: MainViewInputs, interactor: MainInteractor, router: MainRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}


// MARK: - Main View Outputs
extension MainPresenter: MainViewOutputs {
    
    func viewDidLoad() {
        interactor.fetchCharacters()
    }
    
    func onReachBottom() {
        interactor.fetchCharacters()
    }
    
    func refresh() {
        view.showActivityIndicator()
        interactor.resetEntity()
        interactor.fetchCharacters()
    }
    
    func search(with searchText: String) {
        resetView()
        
        if searchText.isEmpty {
            interactor.fetchCharacters(parameters: ["name": nil])
        } else {
            interactor.fetchCharacters(parameters: ["name": searchText.removingAllWhitespaces])
        }
    }
    
    func resetSearch() {
        resetView()
        interactor.fetchCharacters(parameters: ["name": nil])
    }
    
    func onTapFilter() {
        view.showFilterAlert()
    }
    
    func filterCharacters(with status: Status?) {
        resetView()
        if let status = status {
            interactor.fetchCharacters(parameters: ["status": status.rawValue.lowercased()])
        } else {
            interactor.fetchCharacters(parameters: ["status": nil])
        }
    }
    
    private func resetView() {
        view.emptyCollectionViewData()
        view.showActivityIndicator()
        interactor.resetEntity()
    }
}


// MARK: - Main Interactor Outputs
extension MainPresenter: MainInteractorOutputs {
    
    func onSuccessFetch(characters: [RickAndMortyCharacter]) {
        view.reloadCollectionView(dataSource: MainCollectionViewDataSource(characters: characters))
    }
    
    func onFailureFetch(error: APIError) {
        switch error {
        case .failedToParse:
            print("Failed to parse")
            view.showUnknownError()
        case .receiveNilData:
            print("Receive nil data")
            view.showConnectionError()
        case .statusCodeError(let statusCode):
            print("Error status code: \(statusCode)")
            view.showEmptyMessage()
        }
    }
    
    func onReachMaxPageCount() {
        view.removeActivityIndicator()
    }
}
