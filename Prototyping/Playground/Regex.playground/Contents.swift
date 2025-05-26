import Foundation

let string = "0314DT HKD Chin Ba0708HKDCHIBANgười giới thiệu: Số điện thoại - Họ và tên (Chỉ hiển thị nếu có nhập người giới thiệu)Người giới thiệu: Số điện thoại - Họ và tên (Chỉ hiển thị nếu có nhập người giới thiệu)3636636366363636636363"
//let string = "Số điện thoại"
let regex = #"[^\w\s]"#
//let regex = #"[^\d\sA-Za-zÀ-ÿ]"#
let result = string.replacingOccurrences(of: regex, with: "", options: .regularExpression)

let regexObj = try! NSRegularExpression(pattern: regex)
let range = NSRange(location: 0, length: string.utf16.count)
let containsInvalidCharacter = regexObj.firstMatch(in: string, options: [], range: range) != nil

let finalString = (result.applyingTransform(.stripDiacritics, reverse: false) ?? "")
                    .replacingOccurrences(of: "đ", with: "d")
                    .replacingOccurrences(of: "Đ", with: "D")

print("containsInvalidCharacter: ", containsInvalidCharacter)

print(result, result.count, separator: "\n")
print(finalString)

public func format(text: String) -> String {
    String(
    (text.replacingOccurrences(of: #"[^\w\s]"#, with: "", options: .regularExpression)
        .applyingTransform(.stripDiacritics, reverse: false) ?? "")
        .replacingOccurrences(of: "đ", with: "d")
        .replacingOccurrences(of: "Đ", with: "D")
        .prefix(140)
    )
}
let formattedText = format(text: String(string.prefix(140)))
print(formattedText, formattedText.count)
