//
//  LottieViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 17/12/24.
//

import UIKit
import SnapKit
import Then
import Lottie

final class LottieViewController: UIViewController {

    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(filePath: Bundle.main.path(forResource: "Animation-lookback", ofType: "json") ?? "")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1
        animationView.play()
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.then(view.addSubview).snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

#Preview {
    LottieViewController()
}
