//
//  MainEntity.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

struct MainEntity {
        
    /// Array of characters returned from the API
    var characters: [RickAndMortyCharacter] = []
    
    // Default value is 2 to enable first time pagination
    var maxPage = 2
    
    /// The current pagination count
    var pageCount = 1
    
    /// Boolean representing the current state of API fetching
    var isFetching = false
}
