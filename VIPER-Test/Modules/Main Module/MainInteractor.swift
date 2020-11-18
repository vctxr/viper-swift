//
//  MainInteractor.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import Foundation

protocol MainInteractorOutputs: AnyObject {
    func onMessageFetched(message: String)
}

final class MainInteractor: Interactorable {
    
    weak var presenter: MainInteractorOutputs?
    
    func fetchMessage() {
        presenter?.onMessageFetched(message: "hello, viper")
    }
}
