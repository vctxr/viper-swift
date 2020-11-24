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
    
    private static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func buildView() -> MainViewController {
        let view = storyboard.instantiateInitialViewController() as! MainViewController
        let router = MainRouter(view: view)
        let interactor = MainInteractor(entity: MainEntity())
        let presenter = MainPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        view.collectionViewDataSource = MainCollectionViewDataSource(characters: [])
        interactor.presenter = presenter
        return view
    }
}
