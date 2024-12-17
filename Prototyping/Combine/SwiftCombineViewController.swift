//
//  SwiftCombineViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 8/8/24.
//

import UIKit
import SnapKit
import Combine

final class SwiftCombineViewController: UIViewController {

    let btnReload = UIButton()
    var cancelable = Set<AnyCancellable>()
    var testPublisher = PassthroughSubject<Int, Error>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btnReload)

        btnReload.setTitle("Reload", for: .normal)
        btnReload.setTitleColor(.systemBlue, for: .normal)
        btnReload.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        btnReload.addTarget(self, action: #selector(reloadData), for: .touchUpInside)

        testPublisher.sink { complete in

        } receiveValue: {
            print("Receive value: \($0)")
        }
        .store(in: &cancelable)

        makeError()

    }

    @objc func reloadData() {
        if Int.random(in: 0..<10) & 1 == 0 {
            makeError()
        }

        print("good")
    }

    func makeError() {
        print("error")
    }
}

@available(iOS 17, *)
#Preview {
    SwiftCombineViewController()
}
