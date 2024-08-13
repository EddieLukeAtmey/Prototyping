//
//  PrototypingApp.swift
//  Prototyping
//
//  Created by Ngoc Dang on 23/7/24.
//

import SwiftUI

@main
struct PrototypingApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            MyViewControllerRepresentable()
        }
    }
}

struct MyViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = Snapkit2ViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
//        return UIStoryboard(name: "StackButtonsViewController", bundle: nil).instantiateInitialViewController()!
        .init()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Update the view controller if needed
    }
}

@available(iOS 17, *)
#Preview {
    UIViewController()
}
