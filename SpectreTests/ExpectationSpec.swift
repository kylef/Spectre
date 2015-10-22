import Spectre


describe("Expectation") {
  $0.it("can be created from a value") {
    let expectation = expect("value")
    let value = try expectation.expression()

    assert(value == "value")
  }

  $0.describe("equality extensions") {
    $0.describe("`==` operator") {
      $0.it("continues when the rhs is the same value") {
        do {
          try expect("value") == "value"
        } catch {
          fatalError()
        }
      }

      $0.it("throws when the expectation is different") {
        do {
          try expect("value") == "value2"
          fatalError()
        } catch {
        }
      }

      $0.it("throws when the expectation's value is nil") {
        do {
          try expect(nil) == "value"
          fatalError()
        } catch {
        }
      }
    }

    $0.describe("`!=` operator") {
      $0.it("continues when the rhs is not the same value") {
        do {
          try expect("value") != "value2"
        } catch {
          fatalError()
        }
      }

      $0.it("throws when the rhs is the same as the value") {
        do {
          try expect("value") != "value"
          fatalError()
        } catch {
        }
      }
    }
  }
}
