import UIKit

var greeting = "Hello, playground"

func checkDefer() {
    var x = false
    defer { print(x) }

    x = true
}

checkDefer()

let arr1 = (0..<100).map { _ in Int.random(in: 0..<100) }
let arr2 = (0..<100).map { _ in Int.random(in: 100..<200) }

let final = Set(arr1).sorted(by: <) + Set(arr2).sorted(by: <)
print(final)

print(final.count)

