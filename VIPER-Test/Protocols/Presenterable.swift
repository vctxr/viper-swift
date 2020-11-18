//
//  Presenterable.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

protocol Presenterable {
    
    associatedtype I: Interactorable
    associatedtype R: Routerable
    
    var interactor: I { get }
    var router: R { get }
}
