//  ParallaxViewController.swift
//  Prototyping
//
//  Created by Eddie on 10/4/25.
//  

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class ParallaxViewController: UIViewController {
    enum ParalaxType {
        case tilt
        case rotate
    }

    private var paralexType: ParalaxType = .rotate {
        didSet { addParallaxToView(vw: bgDynamic) }
    }

    let bgStatic = UIImageView(image: .bgGreen)
    let bgDynamic = UIImageView(image: .bgDynamicGold)
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgDynamic)
        view.addSubview(bgStatic)

        bgStatic.contentMode = .scaleAspectFit
        bgDynamic.contentMode = .scaleAspectFit

        bgDynamic.snp.makeConstraints { $0.edges.equalToSuperview() }
        bgStatic.snp.makeConstraints { $0.edges.equalToSuperview() }

        setupButtons()
        addParallaxToView(vw: bgDynamic)
    }

    func addParallaxToView(vw: UIView) {
        vw.motionEffects.removeAll()

        let group = UIMotionEffectGroup()
        defer { vw.addMotionEffect(group) }

        switch paralexType {
        case .tilt:
            let amount = 100
            let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            horizontal.minimumRelativeValue = -amount
            horizontal.maximumRelativeValue = amount

            let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            vertical.minimumRelativeValue = -amount
            vertical.maximumRelativeValue = amount
            group.motionEffects = [horizontal, vertical]

        case .rotate:
            let amount = CGFloat.pi / 8
            let horizontal = UIInterpolatingMotionEffect(keyPath: "transform.rotation", type: .tiltAlongHorizontalAxis)
            horizontal.minimumRelativeValue = -amount
            horizontal.maximumRelativeValue = amount

            let vertical = UIInterpolatingMotionEffect(keyPath: "transform.rotation", type: .tiltAlongVerticalAxis)
            vertical.minimumRelativeValue = -amount
            vertical.maximumRelativeValue = amount
            group.motionEffects = [horizontal, vertical]
        }
    }

    private func setupButtons() {
        UIStackView().then(view.addSubview).then {
            $0.spacing = 16
            $0.distribution = .fillEqually
            $0.superview?.bringSubviewToFront($0)

            UIButton(type: .system).then($0.addArrangedSubview).then {
                $0.setTitle("Tilt", for: .normal)
            }.tapPublisher.sink { [unowned self] in
                paralexType = .tilt
            }.store(in: &cancellables)

            UIButton(type: .system).then($0.addArrangedSubview).then {
                $0.setTitle("Rotate", for: .normal)
            }.tapPublisher.sink { [unowned self] in
                paralexType = .rotate
            }.store(in: &cancellables)
            
        }.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(48)
        }
    }
}

#Preview {
    ParallaxViewController()
}
