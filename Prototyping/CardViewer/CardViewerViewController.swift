//
//  CardViewerViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 5/9/24.
//

import UIKit
import SnapKit

final class CardViewerViewController: UIViewController {

    private var cardImage = Rotate3DImageView(frontImage: "visa_priority_front", backImage: "visa_priority_back")!

    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImage = UIImageView(image: .init(named: "visa_priority_bg"))
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.addSubview(cardImage)
        cardImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        cardImage.transform = cardImage.transform.rotated(by: .pi / 4)
    }
}

#Preview {
    CardViewerViewController()
}
