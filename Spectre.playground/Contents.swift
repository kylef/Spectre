//: Playground - noun: a place where people can play

import Spectre

struct Person : CustomStringConvertible {
    let name:String
    
    init(name:String) {
        self.name = name
    }
    
    var description:String {
        return name
    }
}

describe("a person") {
    let person = Person(name: "Kyle")
    
    $0.it("has a name") {
        try expect(person.name) == "Katie"
    }
    
    $0.it("returns the name as description") {
        try expect(person.description) == "Kyle"
    }
}

