//
//  UIString+Extensions.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 24/11/20.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    
    /// Removes all whitespaces in place
    var removingAllWhitespaces: Self {
        filter { !$0.isWhitespace }
    }
    
    mutating func removeAllWhitespaces() {
        removeAll(where: \.isWhitespace)
    }
}
