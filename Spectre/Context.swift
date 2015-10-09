public protocol ContextType {
  func context(name:String, closure:ContextType -> ())
  func describe(name:String, closure:ContextType -> ())
  func before(closure:() -> ())
  func after(closure:() -> ())
  func it(name:String, closure:() throws -> ())
}

class Context : ContextType, CaseType {
  let name:String
  var cases = [CaseType]()

  typealias Before = (() -> ())
  typealias After = (() -> ())

  var befores = [Before]()
  var afters = [After]()

  init(name:String) {
    self.name = name
  }

  func context(name:String, closure:ContextType -> ()) {
    let context = Context(name: name)
    closure(context)
    cases.append(context)
  }

  func describe(name:String, closure:ContextType -> ()) {
    let context = Context(name: name)
    closure(context)
    cases.append(context)
  }

  func before(closure:() -> ()) {
    befores.append(closure)
  }

  func after(closure:() -> ()) {
    afters.append(closure)
  }

  func it(name:String, closure:() throws -> ()) {
    cases.append(Case(name: name, closure: closure))
  }

  func run(reporter:ContextReporter) {
    reporter.report(name) { reporter in
      cases.forEach {
        befores.forEach { $0() }
        $0.run(reporter)
        afters.forEach { $0() }
      }
    }
  }
}

