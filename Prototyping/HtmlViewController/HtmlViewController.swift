//  HtmlViewController.swift
//  Prototyping
//
//  Created by Eddie on 18/3/25.
//  

import UIKit

final class HtmlViewController: UIViewController {
    let html = #"<ol><li>1th item</li><li>2th item</li><li>3rd item</li></ol>"#

    override func viewDidLoad() {
        super.viewDidLoad()
        UIScrollView().then(view.addSubview).then {
            UILabel().then($0.addSubview).then {
                $0.attributedText = htmlString
                $0.numberOfLines = 0
            }.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(24)
                $0.centerX.equalToSuperview()

            }
        }.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private var htmlString: NSAttributedString {
        try! NSAttributedString(data: Data(html.utf8),
                                options: [.documentType: NSAttributedString.DocumentType.html,
                                          .characterEncoding:String.Encoding.utf8.rawValue].with {
                                              if #available(iOS 18, *) { // Fix render html's <ol> <li> in iOS 18
                                                  $0[.textKit1ListMarkerFormatDocumentOption] = true
                                              }
                                              print($0)
                                          },
                                documentAttributes: nil)
    }
}

#Preview {
    HtmlViewController()
}
