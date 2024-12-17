//
//  LineChartView.swift
//  Prototyping
//
//  Created by Ngoc Dang on 13/8/24.
//

import UIKit

final class LineChartView: UIView {
    var happyData = [ChartData]()
    var normalData = [ChartData]()

    init(happyData: [ChartData], normalData: [ChartData]) {
        super.init(frame: .zero)
        self.happyData = happyData
        self.normalData = normalData
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let maxYValue = happyData.last?.value, let context = UIGraphicsGetCurrentContext() else { return }

        context.clear(rect)
        let scaleY = rect.height / maxYValue
        let scaleX = rect.width / CGFloat(happyData.count - 1)

//        animationMaskLayer.path = fullViewRectPath;
        // self.drawEmptyData(points: points, scaleUnitX: CGFloat(scaleUnit.x))

        // add translate layer
//        let animationGradient = CABasicAnimation(keyPath: "position")
//        animationGradient.fromValue = CGPoint(x: 0, y: 0)
//        animationGradient.toValue = CGPoint(x: view.bounds.width, y: 0)
//        animationGradient.duration = 0.5
//        animationGradient.autoreverses = false
//        animationGradient.isRemovedOnCompletion = true
//        animationGradient.fillMode = CAMediaTimingFillMode.forwards
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//            self.animationMaskLayer.position = CGPoint(x: view.bounds.width, y: 0)
//        }

//        animationMaskLayer.add(animationGradient, forKey: "postition")

        // Draw the happy values line
        context.setStrokeColor(UIColor(red: 0.0, green: 0.53, blue: 0.54, alpha: 1.0).cgColor)
        context.setLineWidth(2.0)

        let happyPath = CGMutablePath()

        for (index, data) in happyValues.enumerated() {
//            let xPosition = CGFloat(index) * scaleX
//            let yPosition = (1 - CGFloat(data.value / maxYValue)) * (height - 2 * yPadding)
//
//            if index == 0 {
//                happyPath.move(to: CGPoint(x: xPosition, y: yPosition))
//            } else {
//                happyPath.addLine(to: CGPoint(x: xPosition, y: yPosition))
//            }
        }

        context.addPath(happyPath)
        context.strokePath()

        // Draw the normal values line
//        context.setStrokeColor(UIColor.gray.cgColor)
//        context.setLineWidth(2.0)

//        let normalPath = CGMutablePath()

//        for (index, data) in normalValues.enumerated() {
//            let xPosition = xPadding + CGFloat(data.month - 1) / 11 * (width - 2 * xPadding)
//            let yPosition = yPadding + (1 - CGFloat(data.value / maxYValue)) * (height - 2 * yPadding)
//
//            if index == 0 {
//                normalPath.move(to: CGPoint(x: xPosition, y: yPosition))
//            } else {
//                normalPath.addLine(to: CGPoint(x: xPosition, y: yPosition))
//            }
//        }

//        context.addPath(normalPath)
//        context.strokePath()
    }
}

#Preview {
    let chartView = MyChartView(happyData: happyValues, normalData: normalValues)
    chartView.backgroundColor = .lightGray.withAlphaComponent(0.1)
    chartView.makeSubviews()

    let vc = UIViewController()
    vc.loadViewIfNeeded()
    vc.view.addSubview(chartView)

    chartView.snp.makeConstraints {
        $0.width.equalTo(vc.view.snp.width)
        $0.height.equalTo(vc.view.snp.width).multipliedBy(0.5)
        $0.center.equalToSuperview()
    }

    return vc
}
