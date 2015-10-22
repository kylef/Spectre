class PlaygroundReporter : ContextReporter {
  var depth = 0

  func print(message:String) {
    let indentation = String(count: depth * 2, repeatedValue: " " as Character)
    Swift.print("\(indentation)\(message)")
  }

  func report(name:String, @noescape closure: ContextReporter -> ()) {
    print("\(name):")

    ++depth
    closure(self)
    --depth

    print("")
  }

  func addSuccess(name:String) {
    print("✓ \(name)")
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

