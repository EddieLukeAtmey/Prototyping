//
//  SwiftUIViewContainer.swift
//  Prototyping
//
//  Created by Eddie on 26/11/24.
//

import SwiftUI
import UIKit
import SnapKit

class SwiftUIViewContainer<Content: View>: UIView {
    init(swiftUIView: Content) {
        super.init(frame: .zero)

        // Create a hosting controller with the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIView)

        // Add the hosting controller's view as a subview
        addSubview(hostingController.view)

        // Pin the hosting controller's view to the edges of this container
        hostingController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        // Prevent the hosting controller from interfering with parent VC hierarchy
        hostingController.didMove(toParent: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SwiftUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let subview = SwiftUIViewContainer(swiftUIView: ContentView())
        view.addSubview(subview)
        subview.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

#Preview {
    SwiftUIViewController()
}
