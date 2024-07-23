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
    func makeUIViewController(context: Context) -> MyViewController {
        return MyViewController()
    }

    func updateUIViewController(_ uiViewController: MyViewController, context: Context) {
        // Update the view controller if needed
    }
}

