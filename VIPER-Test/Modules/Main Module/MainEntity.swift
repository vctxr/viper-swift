//
//  MainEntity.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

final class MainEntity {
        
    /// Array of characters returned from the API
    var characters: [RickAndMortyCharacter] = []
    
    /// Default value is 1 to enable first time pagination
    var maxPage = 1
    
    /// The current pagination count
    var pageCount = 1
    
    /// Boolean representing the current state of API fetching
    var isFetching = false
    
    /// The request's parameters
    var parameters: [String: String] = [:]
}
