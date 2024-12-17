//
//  CustomViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 22/10/24.
//

import UIKit

final class CustomViewController: UIViewController {

    override func loadView() {
        view = MyCustomView()
    }
}
