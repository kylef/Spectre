class PlaygroundReporter : ContextReporter {
  var depth = 0

#if swift(>=3.0)
  func print(_ message: String) {
    let indentation = String(repeating: " ", count: depth * 2)
      Swift.print("\(indentation)\(message)")
  }
#else
  func print(message: String) {
    let indentation = String(count: depth * 2, repeatedValue: " " as Character)
    Swift.print("\(indentation)\(message)")
  }
#endif

  func report(_ name: String, closure: (ContextReporter) -> Void) {
    print("\(name):")

    depth += 1
    closure(self)
    depth -= 1

    print("")
  }

  func addSuccess(_ name: String) {
    print("✓ \(name)")
  }

  func addDisabled(_ name: String) {
    print("✱ \(name)")
  }

  func addFailure(_ name: String, failure: FailureType) {
    print("✗ \(name)")
  }
}

let reporter = PlaygroundReporter()

#if swift(>=3.0)
public func describe(_ name: String, closure: (ContextType) -> ()) {
  let context = Context(name: name)
  closure(context)
  context.run(reporter: reporter)
}
#else
public func describe(name: String, closure: ContextType -> ()) {
  let context = Context(name: name)
  closure(context)
  context.run(reporter)
}
#endif

public func it(name: String, closure: @escaping () throws -> ()) {
  let testCase = Case(name: name, closure: closure)
  testCase.run(reporter: reporter)
}

