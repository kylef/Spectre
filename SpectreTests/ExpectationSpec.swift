import Spectre


describe("Expectation") {
  $0.it("can be created from a value") {
    let expectation = expect("value")
    let value = try expectation.expression()

    assert(value == "value")
  }

  $0.describe("comparison to nil") {
    let name: String? = nil

    $0.it("errors when value is not nil") {
      do {
        try expect("kyle").to.beNil()
        fatalError()
      } catch {}
    }

    $0.it("passes when value is nil") {
      try expect(name).to.beNil()
    }
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

  $0.context("with a boolean value") {
    $0.it("can check if the value is true") {
      try expect(true).to.beTrue()
    }

    $0.it("throws an error when the value is not true") {
      do {
        try expect(false).to.beTrue()
        fatalError()
      } catch {}
    }

    $0.it("can check if the value is false") {
      try expect(false).to.beFalse()
    }

    $0.it("throws an error when the value is not true") {
      do {
        try expect(true).to.beFalse()
        fatalError()
      } catch {}
    }
  }

  $0.describe("error handling") {
    enum FileError : ErrorType {
      case NotFound
      case NoPermission
    }

    func throwing() throws {
      throw FileError.NotFound
    }

    func nonThrowing() throws {}

    $0.it("doesn't throw if error is the same") {
      try expect(try throwing()).toThrow(FileError.NotFound)
    }

    $0.it("throws if the error differs") {
      do {
        try expect(try throwing()).toThrow(FileError.NoPermission)
        fatalError()
      } catch {}
    }

    $0.it("throws if no error was provided") {
      do {
        try expect(try nonThrowing()).toThrow()
        fatalError()
      } catch {}
    }
  }
}
