//
//  PrototypingApp.swift
//  Prototyping
//
//  Created by Ngoc Dang on 23/7/24.
//

import SwiftUI
import UIKit

@main
struct PrototypingApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            MyViewControllerRepresentable()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MyViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
//    typealias UIViewControllerType = ChartViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
//        return UIStoryboard(name: "StackButtonsViewController", bundle: nil).instantiateInitialViewController()!
//        return .init() // default VC

        let root = UIViewController()
        root.title = "root"
        let nav = UINavigationController(rootViewController: root)
        nav.pushViewController(CustomNavigationBackViewController(), animated: false)
//        nav.isNavigationBarHidden = true
        return nav

    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Update the view controller if needed
    }
}

@available(iOS 17, *)
#Preview {
    MyViewControllerRepresentable()
        .edgesIgnoringSafeArea(.all)
}
