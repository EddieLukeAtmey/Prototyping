//
//  LottieViewController.swift
//  Prototyping
//
//  Created by Eddie on 17/12/24.
//

import UIKit
import SnapKit
import Then
import Lottie

final class LottieViewController: UIViewController {

    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(filePath: Bundle.main.path(forResource: "Animation_Lookback", ofType: "json")!)
        animationView.loopMode = .autoReverse
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1
        animationView.play()
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.then(view.addSubview).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

#Preview {
    LottieViewController()
}
