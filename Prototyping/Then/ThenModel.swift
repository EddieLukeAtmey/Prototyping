//  ThenModel.swift
//  Prototyping
//
//  Created by Eddie on 19/2/25.
//  

import Foundation
import Then

struct RegisterKidAccountModel: Then {
    let name: String
    let dateOfBirth: Date
    var password: String?
}

import UIKit
#Preview {

    if true {
        let x = RegisterKidAccountModel(name: "name", dateOfBirth: .init())
        let y = x.with { $0.password = "new password" }
        print("x: ", x, "\ny: ", y)
    }

    return UIViewController()
}
