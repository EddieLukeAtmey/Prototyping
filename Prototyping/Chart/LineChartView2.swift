//
//  LineChartView2.swift
//  Prototyping
//
//  Created by Eddie on 13/8/24.
//

import SwiftUI
import Charts

// SwiftUI View for the chart
struct LineChartView2: View {
    let happyData: [ChartData]
    let normalData: [ChartData]

    var body: some View {
        Chart {
            ForEach(happyData, id: \.month) { data in
                LineMark(
                    x: .value("Month", data.month),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(Color(red: 0.0, green: 0.53, blue: 0.54)) // Green color
            }

            ForEach(normalData, id: \.month) { data in
                LineMark(
                    x: .value("Month", data.month),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(Color.black) // Gray color
            }
        }
        .chartXAxis {
            AxisMarks(preset: .extended, values: .stride(by: .month, count: 6))
        }
        .chartYAxis {
            AxisMarks(preset: .inset, position: .leading, values: [0, 10, 10e6])
        }
        .chartXScale(domain: 1...12)
        .chartYScale(domain: 0...6_200_000)
    }
}

#Preview {
    GeometryReader { geometry in
        LineChartView2(happyData: happyValues, normalData: normalValues)
            .frame(width: geometry.size.width, height: geometry.size.width) // 1:1 aspect ratio
            .padding()
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
}
