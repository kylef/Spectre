import Spectre


public func testExpectation() {
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
    
    $0.it("errors when value is nil") {
      try expect("name").to.not.beNil()
      
      do {
        try expect(name).to.not.beNil()
        fatalError()
      } catch {}
    }
  }
  
  $0.describe("comparison to type") {
    class Animal {open func move() {}}
    class Bear: Animal {func rawr() {}}
    
    $0.it("errors when value is not the same type") {
      do {
        try expect("kyle").to.beOfType(Bool.self)
        fatalError()
      } catch {}
    }
    
    $0.it("passes when value is the same value type") {
      try expect(true).to.beOfType(Bool.self)
    }
    
    $0.it("passes when value is the same object type") {
      try expect(Animal()).to.beOfType(Animal.self)
    }
    
    $0.it("fails when value is a subclass of an object type") {
      do {
        try expect(Bear()).to.beOfType(Animal.self)
        fatalError()
      } catch {}
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
        let value: String? = nil
        do {
          try expect(value) == "value"
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
    enum FileError : Error {
      case notFound
      case noPermission
    }
    enum AnotherError: Error {}

    func throwing() throws {
      throw FileError.notFound
    }

    func nonThrowing() throws {}

    $0.it("doesn't throw if error is the same") {
      try expect(throwing()).to.throw(FileError.notFound)
    }

    $0.it("throws if the error differs") {
      do {
        try expect(throwing()).to.throw(FileError.noPermission)
        fatalError()
      } catch {}
    }

    $0.it("throws if the error did not match") {
      do {
        try expect(throwing()).to.throw({ $0 is AnotherError })
        fatalError()
      } catch {}
    }

    $0.it("throws if no error was provided") {
      do {
        try expect(nonThrowing()).to.throw()
        fatalError()
      } catch {}
    }
    
    $0.it("throws if error when no error expected") {
      try expect(nonThrowing()).to.not.throw()
      
      do {
        try expect(throwing()).to.not.throw()
        fatalError()
      } catch {}
    }
  }

  $0.describe("comparable") {
    $0.it("can compare using the > operator") {
      try expect(5) > 2

      do {
        try expect(5) > 5
        fatalError()
      } catch {}
    }

    $0.it("can compare using the >= operator") {
      try expect(5) >= 5

      do {
        try expect(5) >= 6
        fatalError()
      } catch {}
    }

    $0.it("can compare using the < operator") {
      try expect(5) < 6

      do {
        try expect(5) < 5
        fatalError()
      } catch {}
    }

    $0.it("can compare using the <= operator") {
      try expect(5) <= 5

      do {
        try expect(5) <= 4
        fatalError()
      } catch {}
    }
  }
}
}
