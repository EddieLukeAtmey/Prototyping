//
//  Snapkit2ViewController.swift
//  Prototyping
//
//  Created by Eddie on 1/8/24.
//

import UIKit
import SnapKit

final class Snapkit2ViewController: UIViewController {

    let navigationView = UIView()
    let navigationLeftView = UIView()
    let stvTitleView = UIStackView()

    override func loadView() {
        super.loadView()
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
    }

    private func setupNavigationUI() {
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }

        // Left icon
        let leftNavigationView = UIView()
        navigationView.addSubview(leftNavigationView)
        leftNavigationView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(navigationView.snp.leading).offset(4)
            $0.width.equalTo(leftNavigationView.snp.height).multipliedBy(1)
        }

        let imageBack = UIImageView()
        leftNavigationView.addSubview(imageBack)
        imageBack.image = .init(systemName: "chevron.backward")
        imageBack.contentMode = .center
        imageBack.snp.makeConstraints {
            $0.center.equalTo(leftNavigationView.snp.center)
            $0.size.equalTo(24)
        }

        // Title
        let stvNavigationTitle = UIStackView()
        navigationView.addSubview(stvNavigationTitle)
        stvNavigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(leftNavigationView.snp.trailing)
        }

        stvNavigationTitle.axis = .vertical
        stvNavigationTitle.alignment = .center
        stvNavigationTitle.distribution = .fill

        let titleLabel = UILabel()
        stvNavigationTitle.addArrangedSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.text = .init(repeating: "title", count: 2)
        titleLabel.textColor = .darkText

        let subtitleLabel = UILabel()
        stvNavigationTitle.addArrangedSubview(subtitleLabel)
        subtitleLabel.text = .init(repeating: "subtitle ", count: 4)
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = .darkText
    }
}

#Preview {
    Snapkit2ViewController()
}
