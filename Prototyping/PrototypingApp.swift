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
//    typealias UIViewControllerType = ParallaxViewController
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
//        return UIStoryboard(name: "StackButtonsViewController", bundle: nil).instantiateInitialViewController()!
//        .init()
        
//        .init(rootViewController: UIViewController()).then {
//            $0.pushViewController(ParallaxViewController(), animated: false)
//        }

//        let root = CustomNavigationBackViewController().then { $0.loadViewIfNeeded() }
//        return UINavigationController(rootViewController: ChatViewController.init(viewModel: ChatViewModel()))

        .init().then { vc in
            vc.view.backgroundColor = .cyan
            DispatchQueue.main.async {

                let bottomSheetVC = BottomSheetInputViewController()
//                bottomSheetVC.isModalInPresentation = true
//                if let sheet = bottomSheetVC.sheetPresentationController {
//                    sheet.detents = [.medium()]
//                    sheet.largestUndimmedDetentIdentifier = .large
//                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                    sheet.prefersEdgeAttachedInCompactHeight = false
//                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
//                    sheet.prefersGrabberVisible = false
//                    sheet.preferredCornerRadius = 32
//                }


                vc.present(bottomSheetVC.bottomSheetWrapperViewController, animated: true)
            }
        }
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
