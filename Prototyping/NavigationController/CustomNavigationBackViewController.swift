//
//  CustomNavigationBackViewController.swift
//  Prototyping
//
//  Created by Eddie on 22/11/24.
//

import UIKit
import SnapKit
import Then

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
        customBack.setup(viewController: self, useEdgeGesture: true) { [weak self] in
            self?.customPopViewController()
        }
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
//        navigationController?.popViewController(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }

    private func customPopViewController() -> [UIViewController]? {

        if let viewControllers = navigationController?.viewControllers, viewControllers.count > 2 {
            let previousVC = viewControllers[viewControllers.count - 3]
            return navigationController?.popToViewController(previousVC, animated: true)
        }

        return nil
    }
}

#Preview {
    let root = UIViewController().then {
        $0.view.backgroundColor = .lightGray
        $0.title = "root"
    }

    let nav = UINavigationController(rootViewController: root)
    nav.pushViewController(UIViewController().then { $0.view.backgroundColor = .red },
                           animated: false)
    nav.pushViewController(UIViewController().then { $0.view.backgroundColor = .blue },
                           animated: false)
    nav.pushViewController(CustomNavigationBackViewController(),
                           animated: false)

    return nav
}
