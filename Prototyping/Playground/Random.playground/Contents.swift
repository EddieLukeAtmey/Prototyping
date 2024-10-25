import UIKit

var greeting = "Hello, playground"

func checkDefer() {
    var x = false
    defer { print(x) }

    x = true
}

checkDefer()
