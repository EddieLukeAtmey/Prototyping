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
//    typealias UIViewControllerType = UINavigationController
    typealias UIViewControllerType = ParallaxViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
//        return UIStoryboard(name: "StackButtonsViewController", bundle: nil).instantiateInitialViewController()!
        .init()
//        .init(rootViewController: UIViewController()).then {
//            $0.pushViewController(ParallaxViewController(), animated: false)
//        }

//        let root = CustomNavigationBackViewController().then { $0.loadViewIfNeeded() }
//        return UINavigationController(rootViewController: ChatViewController.init(viewModel: ChatViewModel()))
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
