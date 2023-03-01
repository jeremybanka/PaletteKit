precedencegroup SingleFowardPipe {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

infix operator |> : SingleFowardPipe

func |> <V, R>(value: V, function: (V) -> R) -> R {
    function(value)
}

enum Next<T> {
   case modifier(Modifier<T>)
   case literal(T)
}
func become<T>(_ nextVersionOfThing: Next<T>) -> (T) -> T {
    return { originalThing in
        switch nextVersionOfThing {
        case .modifier(let modifier): return modifier(originalThing)
        case .literal(let newThing):  return newThing
        }
    }
}
typealias Applicator<X, Y> = (Next<X>) -> Modifier<Y>
typealias Modifier<T> = (T) -> T
