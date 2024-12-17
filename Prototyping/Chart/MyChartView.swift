//
//  LineChartView.swift
//  Prototyping
//
//  Created by Eddie on 13/8/24.
//

import UIKit
import SnapKit

final class MyChartView: UIView {
    var happyData = [ChartData]()
    var normalData = [ChartData]()

    let verticalCount = 3

    init(happyData: [ChartData], normalData: [ChartData]) {
        super.init(frame: .zero)
        self.happyData = happyData
        self.normalData = normalData
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private var stackViewLabels = UIStackView()
    private lazy var labelCurrency = makeLabel(text: "VND", textAlignment: .left)
    private var chartViewContainer = UIView()
    func makeSubviews() {
        guard stackViewLabels.arrangedSubviews.count == 0 else { return }

        stackViewLabels.spacing = 0
        stackViewLabels.distribution = .fillEqually

        stackViewLabels.addArrangedSubview(makeLabel(text: "1 tháng", textAlignment: .left))
        stackViewLabels.addArrangedSubview(makeLabel(text: "6 tháng", textAlignment: .center))
        stackViewLabels.addArrangedSubview(makeLabel(text: "12 tháng", textAlignment: .right))

        addSubview(stackViewLabels)
        stackViewLabels.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        addSubview(labelCurrency)
        labelCurrency.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        addSubview(chartViewContainer)
        chartViewContainer.snp.makeConstraints {
            $0.top.equalTo(labelCurrency.snp.bottom).inset(axisLineLength)
            $0.bottom.equalTo(stackViewLabels.snp.top).inset(axisLineLength)
            $0.horizontalEdges.equalToSuperview().inset(axisLineLength)
        }
        
        let v = LineChartView(happyData: happyData, normalData: normalData)
        chartViewContainer.addSubview(v)
        v.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func makeLabel(text: String, textAlignment: NSTextAlignment) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.textAlignment = textAlignment
        lb.font = .systemFont(ofSize: 10, weight: .bold)
        lb.textColor = .init(rgb: 0x8a8a8a)
        return lb
    }

    // MARK: - Drawing
    // Define the drawing area and scale
    let xPadding: CGFloat = 8
    let yPadding: CGFloat = 20

    /// the length of line display in the axis
    let axisLineLength: CGFloat = 6

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Create the context
        guard let context = UIGraphicsGetCurrentContext() else { return }

        drawAxis(in: rect, context: context)
    }

    private func drawAxis(in rect: CGRect , context: CGContext) {

        // define frame
        let minY = labelCurrency.frame.maxY
        let maxY = stackViewLabels.frame.minY - 2
        
        let minX = axisLineLength + 4
        let maxX = rect.width - axisLineLength - 4

        // Draw x-axis
        // Draw small vertical lines at the beginning and end of the x-axis
        context.setStrokeColor(UIColor(rgb: 0xc1c1c1).cgColor)
        context.setLineWidth(2.0)

        context.move(to: CGPoint(x: minX, y: maxY))
        context.addLine(to: CGPoint(x: minX, y: maxY - axisLineLength))
        context.strokePath()

        context.move(to: CGPoint(x: maxX, y: maxY))
        context.addLine(to: CGPoint(x: maxX, y: maxY - axisLineLength))
        context.strokePath()

        // Draw dots
        let dotSize = CGSize(width: 2, height: 2)

        // Draw with fixed number of dots along the x-axis
        let numberOfDots = 10
        let spacing = (maxX - minX) / CGFloat(numberOfDots + 1)

        for i in 1...numberOfDots {
            let xPosition = xPadding + CGFloat(i) * spacing
            context.setFillColor(UIColor(rgb: 0xc1c1c1).cgColor)
            context.fillEllipse(in: CGRect(x: xPosition - 1,
                                           y: maxY - axisLineLength/2 - dotSize.height/2,
                                           width: dotSize.width,
                                           height: dotSize.height))
        }

        // Draw y-axis
        // Draw small vertical lines at the beginning and end of the y-axis
        let ySpacing = (maxY - minY) / CGFloat(verticalCount + 1)

        var yPosition = maxY - axisLineLength - ySpacing
        var count = 0
        repeat {
            context.setStrokeColor(UIColor(rgb: 0xc1c1c1).cgColor)
            context.setLineWidth(2.0)

            context.move(to: CGPoint(x: 0, y: yPosition))
            context.addLine(to: CGPoint(x: axisLineLength, y: yPosition))
            context.strokePath()

            yPosition -= ySpacing
            count += 1
        } while (count < verticalCount)
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
