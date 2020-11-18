//
//  MainRouter.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import UIKit

final class MainRouter: Routerable {
    
    private(set) weak var view: Viewable!
    
    init(view: Viewable) {
        self.view = view
    }
}

struct MainModuleBuilder {
    
    static func buildView() -> MainViewController {
        let view = MainViewController()
        let interactor = MainInteractor()
        let router = MainRouter(view: view)
        let entity = MainEntity()
        let presenter = MainPresenter(view: view, interactor: interactor, router: router, entity: entity)
        view.presenter = presenter
        view.collectionViewDataSource = MainCollectionViewDataSource(entity: entity)
        interactor.presenter = presenter
        return view
    }
}
