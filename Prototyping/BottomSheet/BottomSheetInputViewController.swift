//  BottomSheetInputViewController.swift
//  Prototyping
//
//  Created by Eddie on 19/5/25.
//  

import UIKit

final class BottomSheetInputViewController: UIViewController {
    let lbTitle = UILabel()
    let lbDescription = UILabel()
    let tfInput = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tfInput.delegate = self
        tfInput.becomeFirstResponder()
        view.backgroundColor = .white
    }

    private func setupUI() {
        let screenWidth = UIScreen.main.bounds.width

        lbTitle.then(view.addSubview).then {
            $0.text = "Maximum 2 line of text"
            $0.preferredMaxLayoutWidth = screenWidth - 32
            $0.numberOfLines = 2
            $0.font = .systemFont(ofSize: 17, weight: .bold)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(36)
        }

        lbDescription.then(view.addSubview).then {
            $0.text = "Maximum 3 line of text"
            $0.preferredMaxLayoutWidth = screenWidth - 32
            $0.numberOfLines = 3
            $0.setContentHuggingPriority(.required, for: .vertical)
        }.snp.makeConstraints {
            $0.horizontalEdges.equalTo(lbTitle.snp.horizontalEdges)
            $0.top.equalTo(lbTitle.snp.bottom).offset(8)
        }

        tfInput.then(view.addSubview).then {
            $0.placeholder = "Hint text"
            $0.backgroundColor = .lightGray
        }.snp.makeConstraints {
            $0.horizontalEdges.equalTo(lbTitle.snp.horizontalEdges)
            $0.top.equalTo(lbDescription.snp.bottom).offset(16)
            $0.height.equalTo(76)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
}

extension BottomSheetInputViewController: BottomSheetPresentable {}
extension BottomSheetInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

#Preview {
    let bottomSheetVC = BottomSheetInputViewController()
    // Set delegate, actions, datasource....

    let vc = UIViewController()
    vc.view.backgroundColor = .cyan
    DispatchQueue.main.async {
        vc.present(bottomSheetVC.bottomSheetWrapperViewController, animated: true)
    }
    return vc
}
