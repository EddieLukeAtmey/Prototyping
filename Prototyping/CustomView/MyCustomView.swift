//
//  MyCustomView.swift
//  Prototyping
//
//  Created by Eddie on 19/9/24.
//

import UIKit
import SnapKit

final class MyCustomView: UIView {
    let switchColor = UISwitch()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: 0, width: 320, height: 100))
        backgroundColor = .lightGray

        addSubview(switchColor)
        switchColor.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        switchColor.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        switchColor.layer.cornerRadius = 16

        switchColor.backgroundColor = .black
        switchColor.onTintColor = nil
        switchColor.thumbTintColor = nil

        switchColor.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    @objc func switchValueChanged() {
        // Handle the switch state change

        switchColor.backgroundColor = .red
        switchColor.onTintColor = .blue
        switchColor.thumbTintColor = .orange
    }
}

#Preview {
    MyCustomView()
}
