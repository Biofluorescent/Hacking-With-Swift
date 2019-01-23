import UIKit

//Extension files named as Type+Modifer.swift
//Example: String+RandomLetter.swift

//Specifically adding functionality to Int type only. Not UInt64 etc...
extension Int {
    //Mutating means it will change its input. Cannot use with constants
    mutating func plusOne() {
        return self += 1
    }

//This way does not modify original value
//    func plusOne() -> Int {
//        return self + 1
//    }
    
    func squared() -> Int {
        return self * self
    }
}

var myInt = 10
myInt.plusOne()
myInt

let i: Int = 8
print(i.squared())

//BinaryInteger is protocol applied to all Int types
extension BinaryInteger {
    //capital Self means "I'll return whatever data type I was used with"
    func squared() -> Self {
        return self * self
    }
}

//Method or property?
//Roughly methods should be verbs, describing a state should be a property
extension String {
    mutating func trim() {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
