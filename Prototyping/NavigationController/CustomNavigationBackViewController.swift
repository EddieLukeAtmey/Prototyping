//
//  CustomNavigationBackViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 22/11/24.
//

import UIKit
import SnapKit

final class CustomNavigationBackViewController: UIViewController {
    let customBack = CustomInteractivePopTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.text = "Hello"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }

        view.backgroundColor = .cyan.withAlphaComponent(0.3)
        customizedNavBack()
    }

    private func customizedNavBack() {
        navigationController?.isNavigationBarHidden = true
        makeCustomNav()
        customBack.setup(viewController: self)
    }

    private func makeCustomNav() {
        let customNavBar = UIView()
        customNavBar.backgroundColor = .lightGray
        let btnBack = UIButton(type: .close)
        customNavBar.addSubview(btnBack)
        btnBack.addTarget(self, action: #selector(popViewController), for: .touchUpInside)

        view.addSubview(customNavBar)
        customNavBar.addSubview(btnBack)

        customNavBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
        }

        btnBack.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(btnBack.snp.height)
        }
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

#Preview {
    let root = UIViewController()
    root.title = "root"
    let nav = UINavigationController(rootViewController: root)
    nav.pushViewController(CustomNavigationBackViewController(), animated: false)

    return nav
}
