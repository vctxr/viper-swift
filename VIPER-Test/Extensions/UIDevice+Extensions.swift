//
//  UIDevice+Extensions.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import UIKit

extension UIDevice {
    
    private var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
    
    var hasNotch: Bool {
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    var safeAreaTopHeight: CGFloat {
        return keyWindow?.safeAreaInsets.top ?? 0
    }
    
    var safeAreaBottomHeight: CGFloat {
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }
}
