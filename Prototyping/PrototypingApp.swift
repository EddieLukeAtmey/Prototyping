//
//  PrototypingApp.swift
//  Prototyping
//
//  Created by Eddie on 23/7/24.
//

import SwiftUI
import UIKit
import Then

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
    typealias UIViewControllerType = PhotoViewerViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
//        return UIStoryboard(name: "StackButtonsViewController", bundle: nil).instantiateInitialViewController()!
        return .init() // default VC
//
//        let root = CustomNavigationBackViewController().then { $0.loadViewIfNeeded() }
//        let nav = UINavigationController(rootViewController: root)
//        nav.pushViewController(CustomNavigationBackViewController(), animated: false)
//        return nav

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
