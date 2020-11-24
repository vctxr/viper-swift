//
//  RickAndMortyAPI.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

struct RickAndMortyAPI {
    
    private static let baseURLString = "https://rickandmortyapi.com/api"
    
    /// Struct object to initiate a request to the rick and morty API
    struct CharacterRequest: Request {
        var url: String {
            return baseURLString + "/character"
        }
        
        /// The request's parameters (ex. name=rick&status=alive)
        var params: [(key: String, value: String)]
    }
    
    /// Fetch characters from the API with the specified page number (default value is 1).
    /// - Parameters:
    ///   - request: CharacterRequest representing the request to be fired
    ///   - completion: Completion handler representing the result type of either a CharacterFetchResult or APIError
    func fetchCharacter(with request: CharacterRequest, completion: @escaping (Result<CharacterFetchResult, APIError>) -> Void) {
        APICaller().fireRequest(httpMethod: .get, request: request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decodedResult = try JSONDecoder().decode(CharacterFetchResult.self, from: data)
                    completion(.success(decodedResult))
                } catch {
                    completion(.failure(.failedToParse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
