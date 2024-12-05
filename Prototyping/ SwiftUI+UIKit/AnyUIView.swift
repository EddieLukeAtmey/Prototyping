//
//  AnyUIView.swift
//  Prototyping
//
//  Created by Ngoc Dang on 26/11/24.
//

import UIKit
import SwiftUI

struct AnyUIView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        return UIViewType()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }

}
