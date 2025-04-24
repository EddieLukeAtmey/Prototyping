//  NumberCounterVC.swift
//  Prototyping
//
//  Created by Eddie on 11/3/25.
//  

import UIKit
import Then

final class NumberCounterVC: UIViewController {
    let label = UILabel()
    var numberCounter: NumberCounter<NSNumber>?
    let numberFormatter = NumberFormatter().then {
        $0.positiveSuffix = "$"
        $0.maximumFractionDigits = 0
        $0.usesGroupingSeparator = true
        $0.groupingSize = 3
        $0.groupingSeparator = "."
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        numberCounter = .init(startValue: 10, endValue: 50) { [weak self] in
            self?.label.text = self?.numberFormatter.string(from: $0)
        }
        numberCounter?.startAnimation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.numberCounter?.startValue = 50
            self.numberCounter?.endValue = 0
            self.numberCounter?.startAnimation()
        }
    }

    private func setupView() {
        label.then(view.addSubview).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

final class NumberCounter<T: NSNumber> {

    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval?

    private var animationDuration: CFTimeInterval = 1.5
    var startValue: T
    var endValue: T

    private var updatingBlock: ((T) -> ())?

    init(startValue: T, endValue: T, updatingBlock: @escaping ((T) -> ())){
        self.startValue = startValue
        self.endValue = endValue
        self.updatingBlock = updatingBlock
    }

    func startAnimation(duration: CFTimeInterval = 1.5) {
        startTime = CACurrentMediaTime()

        displayLink = CADisplayLink(target: self, selector: #selector(updateNumber))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func updateNumber() {

        let startValue: Int = Int(exactly: startValue) ?? 0
        let endValue: Int = Int(exactly: endValue) ?? 0

        guard let startTime = startTime else { return }
        let elapsedTime = CACurrentMediaTime() - startTime
        let progress = min(elapsedTime / animationDuration, 1.0)

        let currentNumber = Double(startValue) + Double(endValue - startValue) * progress
        updatingBlock?(T(value: currentNumber))

        if progress >= 1.0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
}

#Preview {
    NumberCounterVC()
}
