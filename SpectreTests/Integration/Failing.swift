import Spectre

describe("a person") {
  var person:String!

  $0.context("named kyle") {
    person = "Katie"

    $0.it("is Kyle") {
      try expect(person) == "Kyle"
    }
  }
}
