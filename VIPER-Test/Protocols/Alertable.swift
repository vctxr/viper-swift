//
//  Alertable.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 24/11/20.
//

import UIKit

/// Enables the view controller to show custom alerts.
protocol Alertable: UIViewController {
    func presentFilterSheet(title: String?, message: String?, selectedIndex: Int, completion: @escaping (Int) -> Void)
}

extension Alertable {
    
    /// Presents a basic filter alert sheet with the specified title and message.
    func presentFilterSheet(title: String?, message: String?, selectedIndex: Int, completion: @escaping (Int) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: "All", style: .default) { (_) in
            completion(0)
        }
        
        let aliveAction = UIAlertAction(title: "Alive", style: .default) { (_) in
            completion(1)
        }
        
        let deadAction = UIAlertAction(title: "Dead", style: .default) { (_) in
            completion(2)
        }
        
        let unknownAction = UIAlertAction(title: "Unknown", style: .default) { (_) in
            completion(3)
        }
        
        let actions = [allAction, aliveAction, deadAction, unknownAction]
        actions.forEach({ alert.addAction($0) })
        actions[selectedIndex].setValue(true, forKey: "checked")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.pruneNegativeWidthConstraints()       // To silence constraint error

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
