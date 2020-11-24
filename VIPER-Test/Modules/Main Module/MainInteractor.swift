//
//  MainInteractor.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

protocol MainInteractorOutputs: AnyObject {
    func onSuccessFetch(characters: [RickAndMortyCharacter])
    func onFailureFetch(error: APIError)
    func onReachMaxPageCount()
}

final class MainInteractor: Interactorable {
    
    weak var presenter: MainInteractorOutputs?
    private var entity: MainEntity
    
    init(entity: MainEntity) {
        self.entity = entity
    }
    
    func fetchCharacters(parameters: [String: String?]? = nil) {
        guard shouldFetch() else { return }
        
        // Save the parameter for future use
        if let parameters = parameters {
            parameters.forEach { (key, value) in
                entity.parameters[key] = value
            }
        }
    
        // Append the saved parameters
        var params = ["page": "\(entity.pageCount)"]
        entity.parameters.forEach({ (key, value) in
            params[key] = value
        })
        
        let request = RickAndMortyAPI.CharacterRequest(params: params)
        
        RickAndMortyAPI().fetchCharacter(with: request) { [weak self] (result: Result<CharacterFetchResult, APIError>) in
            self?.entity.isFetching = false

            switch result {
            case .success(let characterFetchResult):
                guard let this = self else { return }
                this.entity.pageCount += 1
                this.entity.maxPage = characterFetchResult.info.pages
                this.entity.characters.append(contentsOf: characterFetchResult.characters)
                this.presenter?.onSuccessFetch(characters: this.entity.characters)
                
                if this.entity.pageCount >= this.entity.maxPage {
                    this.presenter?.onReachMaxPageCount()
                }
            case .failure(let error):
                self?.presenter?.onFailureFetch(error: error)
            }
        }
    }
    
    func resetEntity() {
        ImageCacher.shared.imageCache.removeAllObjects()
        entity.characters.removeAll()
        entity.pageCount = 1
    }
}


// MARK: - Helper Functions
extension MainInteractor {
    
    private func shouldFetch() -> Bool {
        guard entity.pageCount <= entity.maxPage else {
            presenter?.onReachMaxPageCount()
            return false
        }
        
        guard !entity.isFetching else { return false }
        entity.isFetching = true
        
        return true
    }
}
