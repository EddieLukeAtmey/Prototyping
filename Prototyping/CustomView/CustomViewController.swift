//
//  CustomViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 22/10/24.
//

import UIKit
import SnapKit

final class CustomViewController: UIViewController {

    //    override func loadView() {
    //        view = MyCustomView()
    //    }

    var action: (() -> Void)?

    let v = BranchCellContentView()
    var entity = BranchCellEntity()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(v)

//        entity.name = "ATM Hoàng Cầu"
        entity.address = "Toà nhà Geleximco, 36 P. Hoàng Cầu"
        entity.distance = "750 m"
        entity.workingStatus = .active
        //    entity.workingTime = "24/7"

        v.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.center.equalToSuperview()
        }

        v.bindEntity(entity)

        let btn = UIButton(type: .close)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-32)
        }

        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
    }

    @objc private func btnAction() {
        action?()
    }
}

#Preview {
    let root = CustomViewController()
    root.entity.name = "ATM Hoàng Cầu"
    let nav = UINavigationController(rootViewController: root)
    
    let vc1 = CustomViewController()
    vc1.entity.name = "hehee"

    let vc2 = CustomViewController()
    vc2.entity.name = "blblbal"

    vc2.action = {
//        nav.popViewController(animated: false)
//        nav.popViewController(animated: true)
        nav.popToViewController(root, animated: true)
    }

    nav.pushViewController(vc1, animated: false)
    nav.pushViewController(vc2, animated: false)

    return nav
}
