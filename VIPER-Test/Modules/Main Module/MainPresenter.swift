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

extension MainPresenter: MainInteractorOutputs {
    
    func onMessageFetched(message: String) {
        view.configureTextLabel(with: message)
    }
}

extension MainPresenter: MainViewOutputs {
    
    func viewDidLoad() {
        interactor.fetchMessage()
    }
}
