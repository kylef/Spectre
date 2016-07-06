class PlaygroundReporter : ContextReporter {
  var depth = 0

  func print(message:String) {
    let indentation = String(count: depth * 2, repeatedValue: " " as Character)
    Swift.print("\(indentation)\(message)")
  }

#if swift(>=3.0)
  func report(_ name: String, closure: @noescape (ContextReporter) -> Void) {
    print("\(name):")

    depth += 1
    closure(self)
    depth -= 1

    print("")
  }
#else
  func report(_ name: String, @noescape closure: (ContextReporter) -> Void) {
    print("\(name):")

    depth += 1
    closure(self)
    depth -= 1

    print("")
  }
#endif

  func addSuccess(name:String) {
    print("✓ \(name)")
  }

  func addDisabled(name: String) {
    print("✱ \(name)")
  }

  func addFailure(name:String, failure: FailureType) {
    print("✗ \(name)")
  }
}

let reporter = PlaygroundReporter()

public func describe(name:String, closure: ContextType -> ()) {
  let context = Context(name: name)
  closure(context)
  context.run(reporter)
}

public func it(name:String, closure:() throws -> ()) {
  let `case` = Case(name: name, closure: closure)
  `case`.run(reporter)
}

