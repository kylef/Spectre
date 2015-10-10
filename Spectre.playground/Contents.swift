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
    try equal(person.name, "Katie")
  }

  $0.it("returns the name as description") {
    try equal(person.description, "Kyle")
  }
}
