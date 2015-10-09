public protocol ContextType {
  func context(name:String, closure:ContextType -> ())
  func describe(name:String, closure:ContextType -> ())
  func before(closure:() throws -> ())
  func after(closure:() throws -> ())
  func it(name:String, closure:() throws -> ())
}

class Context : ContextType, CaseType {
  let name:String
  var cases = [CaseType]()

  //var befores
  //var afters

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

  func before(closure:() throws -> ()) {

  }

  func after(closure:() throws -> ()) {

  }

  func it(name:String, closure:() throws -> ()) {
    cases.append(Case(name: name, closure: closure))
  }

  func run(reporter:ContextReporter) {
    reporter.report(name) { reporter in
      cases.forEach { $0.run(reporter) }
    }
  }
}

