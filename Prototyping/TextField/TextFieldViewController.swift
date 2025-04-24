//  TextFieldViewController.swift
//  Prototyping
//
//  Created by Eddie on 21/3/25.
//  

import UIKit

final class TextFieldViewController: UIViewController {
    let textField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textField)
//        textField.placeholder = "Enter"
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.becomeFirstResponder()
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
            $0.height.equalTo(46)
        }

        UILabel().then(textField.addSubview).then {
            $0.text = "Enter"
        }.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

#Preview {
    TextFieldViewController()
}
