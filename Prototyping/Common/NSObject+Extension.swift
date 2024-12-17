//
//  NSObject+Extension.swift
//  Prototyping
//
//  Created by Eddie on 21/10/24.
//

import Foundation

public extension NSObject {
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
