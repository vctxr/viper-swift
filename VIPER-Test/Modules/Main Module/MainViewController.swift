//
//  MainViewController.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import UIKit

protocol MainViewOutputs: AnyObject {
    func viewDidLoad()
}

protocol MainViewInputs: AnyObject {
    func configureTextLabel(with: String)
}


// MARK: - Main View Controller

final class MainViewController: UIViewController {
    
    var presenter: MainViewOutputs?
    
    @IBOutlet private var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    deinit {
        print("Deinit")
    }
}


// MARK: - Main View Presenter Inputs

extension MainViewController: MainViewInputs {
    
    func configureTextLabel(with text: String) {
        textLabel.text = text
    }
}


extension MainViewController: Viewable {}
