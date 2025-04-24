import Combine

var currentValueSubject = CurrentValueSubject<Bool, Never>(false)
var currentValueSubject2 = CurrentValueSubject<Int, Never>(0)
var passthroughSubject = PassthroughSubject<Int, Never>()

var cancellable = Set<AnyCancellable>()

currentValueSubject.sink {
    print("CurrentValue", $0)
}.store(in: &cancellable)

currentValueSubject2.sink {
    print("CurrentValue2", $0)
}.store(in: &cancellable)

currentValueSubject.combineLatest(currentValueSubject2).sink {
    print("CombineCurrents", $0.0, $0.1)
}

//passthroughSubject.sink {
//    print("Passthrough", $0)
//}.store(in: &cancellable)
//
//
//currentValueSubject.combineLatest(passthroughSubject).sink {
//    print("CurrentCombinePassthrough", $0.0, $0.1)
//}.store(in: &cancellable)
//
//passthroughSubject.combineLatest(currentValueSubject).sink {
//    print("PassthroughCombineCurrent", $0.0, $0.1)
//}.store(in: &cancellable)

//currentValueSubject.send(true)
//passthroughSubject.send(1)
//passthroughSubject.send(2)
//passthroughSubject.send(3)
//passthroughSubject.send(4)
//
//currentValueSubject.send(true)
//passthroughSubject.send(5)
//passthroughSubject.send(6)
//
//currentValueSubject.send(false)
