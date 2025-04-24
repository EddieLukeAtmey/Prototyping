//  Then+Transform.swift
//  Prototyping
//
//  Created by Eddie on 9/1/25.
//  

import Foundation
import Then

extension Then {
    func thenTransform<T>(_ block: (Self) throws -> T) rethrows -> T {
        return try block(self)
    }
}
