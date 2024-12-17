//
//  CustomToastViewController.swift
//  Prototyping
//
//  Created by Eddie on 24/10/24.
//

import UIKit
import SnapKit

final class CustomToastViewTestController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .infoDark)
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        button.addTarget(self, action: #selector(showToast), for: .touchUpInside)
    }

    @objc
    private func showToast() {
        Toast.showUnleashFeatureDisabled(on: self)
    }
}

#Preview {
    CustomToastViewTestController()
}
