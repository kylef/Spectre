import Spectre

describe("a person") {
  var person:String!

  $0.context("named kyle") {
    person = "Kyle"

    $0.it("is Kyle") {
      try equal(person, "Kyle")
    }
  }
}
