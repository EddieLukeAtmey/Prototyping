//
//  ABSwitchButton.swift
//  Prototyping
//
//  Created by Eddie on 22/10/24.
//

import UIKit
import SnapKit

final class ABSwitchButton: UIButton {
    private let theSwitch = UISwitch()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSwitch()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSwitch()
    }

    private func setupSwitch() {
        addSubview(theSwitch)
        theSwitch.isUserInteractionEnabled = false
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        theSwitch.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    var isOn: Bool {
        get { theSwitch.isOn }
        set { theSwitch.isOn = newValue }
    }

    func setOn(_ newValue: Bool, animated: Bool) {
        theSwitch.setOn(newValue, animated: animated)
    }

    var onTintColor: UIColor? {
        get { theSwitch.onTintColor }
        set { theSwitch.onTintColor = newValue }
    }

    var thumbTintColor: UIColor? {
        get { theSwitch.thumbTintColor }
        set { theSwitch.thumbTintColor = newValue }
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {}
    override func setImage(_ image: UIImage?, for state: UIControl.State) {}

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        if bounds.contains(touchLocation) {
            // User tapped the button
            theSwitch.setOn(!isOn, animated: true)
            sendActions(for: .valueChanged)
        }
    }
}

#Preview {
    ABSwitchButton()
}
