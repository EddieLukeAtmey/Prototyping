//
//  ChartViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 13/8/24.
//

import UIKit
import SnapKit
import SwiftUI

final class ChartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

//        let chartView = UIHostingController(rootView: LineChartView(happyData: happyValues, normalData: normalValues)).view!
        let chartView = MyChartView(happyData: happyValues, normalData: normalValues)
        chartView.backgroundColor = .white
        view.addSubview(chartView)
        chartView.makeSubviews()
        chartView.snp.makeConstraints {
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.snp.width).multipliedBy(0.5)
        }
    }
}

//#Preview {
//    ChartViewController()
//}
