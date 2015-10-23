public protocol ContextType {
  func context(name:String, closure:ContextType -> ())
  func describe(name:String, closure:ContextType -> ())
  func before(closure:() -> ())
  func after(closure:() -> ())
  func it(name:String, closure:() throws -> ())
}

class Context : ContextType, CaseType {
  let name:String
  private weak var parent: Context?
  var cases = [CaseType]()

  typealias Before = (() -> ())
  typealias After = (() -> ())

  var befores = [Before]()
  var afters = [After]()

  init(name:String, parent: Context? = nil) {
    self.name = name
    self.parent = parent
  }

  func context(name:String, closure:ContextType -> ()) {
    let context = Context(name: name, parent: self)
    closure(context)
    cases.append(context)
  }

  func describe(name:String, closure:ContextType -> ()) {
    let context = Context(name: name, parent: self)
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

  func runBefores() {
    parent?.runBefores()
    befores.forEach { $0() }
  }

  func runAfters() {
    afters.forEach { $0() }
    parent?.runAfters()
  }

  func run(reporter: ContextReporter) {
    reporter.report(name) { reporter in
      cases.forEach {
        runBefores()
        $0.run(reporter)
        runAfters()
      }
    }
  }
}

