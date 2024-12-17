//
//  StackButtonsViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 24/7/24.
//

import UIKit

final class StackButtonsViewController: UIViewController {

    let scvContainer = UIScrollView()
    let stvContainer = UIStackView()

    override func loadView() {
        super.loadView()
        view = UIView()
        view.addSubview(scvContainer)
        scvContainer.translatesAutoresizingMaskIntoConstraints = false
        stvContainer.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stvContainer.spacing = 12
        stvContainer.distribution = .fillProportionally

        scvContainer.addSubview(stvContainer)
        NSLayoutConstraint.activate([
            scvContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scvContainer.topAnchor.constraint(equalTo: view.topAnchor),
            scvContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scvContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scvContainer.contentLayoutGuide.heightAnchor.constraint(equalTo: scvContainer.heightAnchor),

            stvContainer.leadingAnchor.constraint(equalTo: scvContainer.contentLayoutGuide.leadingAnchor, constant: 16),
            stvContainer.trailingAnchor.constraint(equalTo: scvContainer.contentLayoutGuide.trailingAnchor, constant: 16),
            stvContainer.centerYAnchor.constraint(equalTo: scvContainer.centerYAnchor),
            stvContainer.heightAnchor.constraint(equalToConstant: 36)
        ])

        let selected = UIButton(type: .custom)
        configureButton(selected, title: "Lãi cuối kỳ")
        configureButton(UIButton(), title: "Lãi hàng quý")
        configureButton(UIButton(), title: "Lãi hàng tháng")
        configureButton(UIButton(), title: "Lãi trước")
//        selected.tintColor = .clear
//        selected.adjustsImageWhenHighlighted
        selected.setTitleColor(.green, for: .selected)
//        selected.isSelected = true

        selected.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    }

    func configureButton(_ btn: UIButton, title: String) {

        stvContainer.addArrangedSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
//        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        btn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

//        btn.setTitleColor(Assets.Colors.textDefault.color, for: .normal)
//        btn.setTitleColor(Assets.Colors.textBrand.color, for: .selected)

        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1

        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .red
        config.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
//        config.high
        btn.configuration = config

        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18)
    }
}

#Preview {
    StackButtonsViewController()
}
