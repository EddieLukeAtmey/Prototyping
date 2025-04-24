//  DateFormatterVC.swift
//  Prototyping
//
//  Created by Eddie on 7/3/25.
//  

import UIKit

final class DateFormatterVC: UIViewController {
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        formatDate()
    }

    private func setupView() {
        label.then(view.addSubview).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func formatDate() {
        let dateStr = "2025-03-03T17:47:00+07:00"
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = f.date(from: dateStr)!

        let f2 = DateFormatter()
        f2.dateFormat = "HH:mm:ss - EEEE, dd MMMM, yyyy"
        f2.locale = .init(identifier: "vi")

        label.text = f2.string(from: date)
    }
}

#Preview {
    DateFormatterVC()
}
