//
//  ChartData.swift
//  Prototyping
//
//  Created by Ngoc Dang on 13/8/24.
//

import Foundation

// Define the data structure
struct ChartData {
    let month: Int
    let value: Double
}

// Sample data based on your description
let happyValues: [ChartData] = [
    ChartData(month: 1, value: 271_780.82),
    ChartData(month: 6, value: 2_853_698.63),
    ChartData(month: 12, value: 6_115_068.49)
]

let normalValues: [ChartData] = [
    ChartData(month: 1, value: 8_493.15),
    ChartData(month: 6, value: 50_958.90),
    ChartData(month: 12, value: 101_917.81)
]
