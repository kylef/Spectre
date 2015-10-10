import Darwin


class GlobalContext {
  var cases = [CaseType]()

  func describe(name:String, closure:ContextType -> ()) {
    let context = Context(name: name)
    closure(context)
    cases.append(context)
  }

  func it(name:String, closure:() throws -> ()) {
    cases.append(Case(name: name, closure: closure))
  }

  func run(reporter:Reporter) -> Bool {
    return reporter.report { reporter in
      for `case` in cases {
        `case`.run(reporter)
      }
    }
  }
}

let globalContext: GlobalContext = {
  atexit { run() }
  return GlobalContext()
}()

public func describe(name:String, closure:ContextType -> ()) {
  globalContext.describe(name, closure: closure)
}

public func it(name:String, closure:() throws -> ()) {
  globalContext.it(name, closure: closure)
}

@noreturn public func run() {
  let reporter = StandardReporter()
  run(reporter)
}

@noreturn public func run(reporter:Reporter) {
  if globalContext.run(reporter) {
    exit(0)
  }
  exit(1)
}

