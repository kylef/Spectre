import Spectre

describe("fail assert") {
  $0.it("throws an error") {
    var didFail = false

    do {
      try fail("it's broken")
    } catch {
      didFail = true
    }

    if !didFail {
      // LOL, such crazy.
      try fail("fail didn't throw a failure")
    }
  }
}

describe("equal assert") {
  $0.it("doesn't throw for equal types") {
    var didThrow = false

    do {
      try equal("kyle", "kyle")
    } catch {
      didThrow = true
    }

    if didThrow {
      try fail("equal throwed for equal types")
    }
  }

  $0.it("throws for non-equal types") {
    var didThrow = false

    do {
      try equal("kyle", "delisa")
    } catch {
      didThrow = true
    }

    if !didThrow {
      try fail("equal did not throw for unequal types")
    }
  }
}

describe("notEqual assert") {
  $0.it("throws for equal types") {
    var didThrow = false

    do {
      try notEqual("kyle", "kyle")
    } catch {
      didThrow = true
    }

    if !didThrow {
      try fail("notEqual did not throw for equal types")
    }
  }

  $0.it("throws for non-equal types") {
    var didThrow = false

    do {
      try notEqual("kyle", "delisa")
    } catch {
      didThrow = true
    }

    if didThrow {
      try fail("notEqual did not throw for unequal types")
    }
  }
}

