//
//  NSObject+Extension.swift
//  Prototyping
//
//  Created by Ngoc Dang on 21/10/24.
//

import Foundation

public extension NSObject {
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
