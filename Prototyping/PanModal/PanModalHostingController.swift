//
//  PanModalHostingController.swift
//  Prototyping
//
//  Created by Eddie on 24/9/24.
//

import UIKit
import SnapKit
import PanModal

final class PanModalHostingController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPanModal)))
    }

    @objc private func showPanModal() {
        let vc = PanModalViewController()
        let bottomPadding = view.window?.safeAreaInsets.bottom
        print("PanModalHostingController", bottomPadding ?? -1)
        
        presentPanModal(vc)
    }
}

final class PanModalViewController: UIViewController, PanModalPresentable {
    var panScrollable: UIScrollView? { nil }
    var longFormHeight: PanModalHeight { .intrinsicHeight }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: .init(systemName: "bolt.heart.fill"))
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.size.equalTo(192)
            $0.centerX.equalToSuperview()
        }

        let titleStack = UIStackView()
        view.addSubview(titleStack)
        titleStack.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        titleStack.axis = .vertical
        titleStack.alignment = .center
        titleStack.spacing = 8

        let titleLabel = UILabel()
        titleStack.addArrangedSubview(titleLabel)
        titleLabel.text = "titleLabel"
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.setContentHuggingPriority(.init(999), for: .vertical)
        titleLabel.backgroundColor = .red.withAlphaComponent(0.3)

        let subtitleLabel = UILabel()
        titleStack.addArrangedSubview(subtitleLabel)
        subtitleLabel.text = "subtitleLabel"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.setContentHuggingPriority(.init(998), for: .vertical)
        subtitleLabel.backgroundColor = .cyan.withAlphaComponent(0.3)

        let confirmButton = UIButton(type: .contactAdd)
        view.addSubview(confirmButton)
        confirmButton.backgroundColor = .green
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.width.equalTo(128)
        }

        let denyButton = UIButton(type: .close)
        denyButton.backgroundColor = .green
        view.addSubview(denyButton)

        let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? -1
        let offset = bottomPadding > 0 ? 10 : -24
        denyButton.snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
            $0.width.equalTo(128)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0).priority(.init(997))
            $0.bottom.equalTo(view.snp.bottom).offset(offset).priority(.init(997))
        }
        

//        let bottomPadding = parent?.view.safeAreaInsets.bottom
//        print("PanModalViewController", bottomPadding)
    }
}

#Preview {
    PanModalHostingController()
//    PanModalViewController()
}
