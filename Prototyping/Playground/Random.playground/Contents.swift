import UIKit

var greeting = "Hello, playground"

func checkDefer() {
    var x = false
    defer { print(x) }

    x = true
}

checkDefer()

//let arr1 = (0..<100).map { _ in Int.random(in: 0..<100) }
//let arr2 = (0..<100).map { _ in Int.random(in: 100..<200) }
//
//let final = Set(arr1).sorted(by: <) + Set(arr2).sorted(by: <)
//print(final)
//
//print(final.count)

let v: Decimal = 1e9
print("\(v)")

class Parent {
    let x = "x"
    lazy var y = "y"
}

class Children: Parent {
    override var y: String {
        get { super.y }
        set { super.y = "hehe" }
    }
}

//let phoneRegex = #"^(0[1-9]\d{8}|0[1-9]\d{2}-\d{4}-\d{4})$"#
//let matches = "0909099099".range(of: phoneRegex, options: .regularExpression) != nil
//print(matches)

let separator = "content: "
let response = "title: Some Title\ncontent: This is the content I need content: MoreContent"
if let content = response.components(separatedBy: separator).last {
    print(content) // "This is the content I need"
}

if let match = response.range(of: #"\#(separator).*"#, options: .regularExpression) {
    let content = String(response[match].dropFirst(separator.count))
    print(content) // "This is the content I need"
}
