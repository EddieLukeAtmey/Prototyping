//  LabelStackViewController.swift
//  Prototyping
//
//  Created by Eddie on 6/5/25.
//  

import UIKit
import SnapKit

final class LabelStackViewController: UIViewController {

    let lbLeft = UILabel().then {
        $0.backgroundColor = .systemBlue
        $0.numberOfLines = 0
    }
    let lbRight = UILabel().then {
        $0.backgroundColor = .cyan
        $0.numberOfLines = 0
        $0.textAlignment = .right
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UIStackView().then(view.addSubview).then {
            $0.axis = .vertical
            $0.spacing = 8
            makeStack(left: String(repeating: "X", count: 20),
                      right: String(repeating: "X", count: 1)).do($0.addArrangedSubview)

            makeStack(left: String(repeating: "X", count: 10),
                      right: String(repeating: "X", count: 20)).do($0.addArrangedSubview)

            makeStack(left: String(repeating: "X", count: 10),
                      right: String(repeating: "X", count: 10)).do($0.addArrangedSubview)

            makeStack(left: String(repeating: "X", count: 20),
                      right: String(repeating: "X", count: 20)).do($0.addArrangedSubview)
        }.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.center.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }

    private func makeStack(left: String, right: String) -> UIView {
        UIStackView().then(view.addSubview).then {
            $0.spacing = 12
            $0.alignment = .top

            let lbLeft = UILabel().then {
                $0.backgroundColor = .systemBlue
                $0.numberOfLines = 0
            }

            let lbRight = UILabel().then {
                $0.backgroundColor = .cyan
                $0.numberOfLines = 0
                $0.textAlignment = .right
            }

            $0.addArrangedSubview(lbLeft)
            lbLeft.text = left
            $0.addArrangedSubview(lbRight)
            lbRight.text = right
        }
    }
}

private final class ContentStackView: UIView {

}

#Preview {
    LabelStackViewController()
}
