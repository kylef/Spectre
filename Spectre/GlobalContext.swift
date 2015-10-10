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

