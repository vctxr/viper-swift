//
//  MainInteractor.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

protocol MainInteractorOutputs: AnyObject {
    func onSuccessFetch(result: CharacterFetchResult)
    func onFailureFetch(error: Error)
}

final class MainInteractor: Interactorable {
    
    weak var presenter: MainInteractorOutputs?
    
    func fetchCharacters(page: Int = 1) {
        let request = RickAndMortyAPI.CharacterRequest(page: page)
        
        RickAndMortyAPI().fetchCharacter(with: request) { [weak self] (result: Result<CharacterFetchResult, APIError>) in
            switch result {
            case .success(let characterFetchResult):
                self?.presenter?.onSuccessFetch(result: characterFetchResult)
            case .failure(let error):
                self?.presenter?.onFailureFetch(error: error)
            }
        }
    }
}
