//
//  DecimalViewController.swift
//  Prototyping
//
//  Created by Ngoc Dang on 13/11/24.
//

import UIKit
import SnapKit

final class DecimalViewController: UIViewController {
    let groupingSeparator = ","
    let decimalSeparator = "."

    let tf = UITextField()
    let tf2 = UITextField()
    let lbResult = UILabel()

    override func viewDidLoad() {
        view.addSubview(tf)
        view.addSubview(tf2)
        view.addSubview(lbResult)

        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.backgroundColor = .lightGray

        tf2.borderStyle = .roundedRect
        tf2.delegate = self
        tf2.backgroundColor = .lightGray

        tf.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(40)
            $0.centerY.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(256)
        }

        tf2.snp.makeConstraints {
            $0.top.equalTo(tf.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(256)
        }

        lbResult.snp.makeConstraints {
            $0.top.equalTo(tf2.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }

        lbResult.numberOfLines = 0
        lbResult.textAlignment = .center
    }
}

extension DecimalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newValue = (textField.text as? NSString)?.replacingCharacters(in: range, with: string)
        let val = decimalValue(for: newValue)
        lbResult.text = formattedString(for: val, maximumFractionDigits: 2)

        if let fraction = newValue?.split(separator: decimalSeparator), fraction.count == 2 {
            return fraction[1].count < 2
        }

        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {

        let textDecimalVal = decimalValue(for: textField.text)
        let lbResultDecimalVal = decimalValue(for: lbResult.text)

        guard textDecimalVal == lbResultDecimalVal else { return }

        // Format text
        textField.text = lbResult.text

        // Convert to other field
        var result = lbResult.text
        if let val = decimalValue(for: result) {
            let converted = val * 25.46
            result = formattedString(for: converted, maximumFractionDigits: 2)
        }

        if textField == tf {
            tf2.text = result
        } else {
            tf.text = result
        }
    }

    private func decimalValue(for string: String?) -> Decimal? {
        guard let string = string?.replacingOccurrences(of: groupingSeparator, with: "") else { return nil }
        return Decimal(string: string)
    }

    private func formattedString(for number: Decimal?, maximumFractionDigits: Int = 0) -> String? {
        guard let number else { return nil }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.groupingSeparator = groupingSeparator
        formatter.decimalSeparator = decimalSeparator

        return formatter.string(for: number)
    }
}

#Preview {
    DecimalViewController()
}
