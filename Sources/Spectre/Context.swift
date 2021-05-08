public protocol ContextType {
  /// Creates a new sub-context
  func context(_ name: String, closure: (ContextType) -> Void)

  /// Creates a new sub-context
  func describe(_ name: String, closure: (ContextType) -> Void)

  /// Creates a new disabled sub-context
  func xcontext(_ name: String, closure: (ContextType) -> Void)

  /// Creates a new disabled sub-context
  func xdescribe(_ name: String, closure: (ContextType) -> Void)

  func before(_ closure: @escaping () -> Void)
  func after(_ closure: @escaping () -> Void)

  /// Adds a new test case
  func it(_ name: String, file: String, line: Int, closure: @escaping () throws -> Void)

  /// Adds a disabled test case
  func xit(_ name: String, file: String, line: Int, closure: @escaping () throws -> Void)
}

extension ContextType {
  public func it(_ name: String, file: String = #file, line: Int = #line, closure: @escaping () throws -> Void) {
    it(name, file: file, line: line, closure: closure)
  }

  public func xit(_ name: String, file: String = #file, line: Int = #line, closure: @escaping () throws -> Void) {
    xit(name, file: file, line: line, closure: closure)
  }
}

class Context : ContextType, CaseType {
  let name: String
  var disabled: Bool
  fileprivate weak var parent: Context?
  var cases = [CaseType]()

  typealias Before = (() -> Void)
  typealias After = (() -> Void)

  var befores = [Before]()
  var afters = [After]()

  init(name: String, disabled: Bool = false, parent: Context? = nil) {
    self.name = name
    self.disabled = disabled
    self.parent = parent
  }

  func context(_ name: String, closure: (ContextType) -> Void) {
    let context = Context(name: name, parent: self)
    closure(context)
    cases.append(context)
  }

  func describe(_ name: String, closure: (ContextType) -> Void) {
    let context = Context(name: name, parent: self)
    closure(context)
    cases.append(context)
  }

  func xcontext(_ name: String, closure: (ContextType) -> Void) {
    let context = Context(name: name, disabled: true, parent: self)
    closure(context)
    cases.append(context)
  }

  func xdescribe(_ name: String, closure: (ContextType) -> Void) {
    let context = Context(name: name, disabled: true, parent: self)
    closure(context)
    cases.append(context)
  }

  func before(_ closure: @escaping () -> Void) {
    befores.append(closure)
  }

  func after(_ closure: @escaping () -> Void) {
    afters.append(closure)
  }

  func it(_ name: String, file: String, line: Int, closure: @escaping () throws -> Void) {
    cases.append(Case(name: name, closure: closure, file: file, line: line))
  }

  func xit(_ name: String, file: String, line: Int, closure: @escaping () throws -> Void) {
    cases.append(Case(name: name, disabled: true, closure: closure, file: file, line: line))
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
    if disabled {
      reporter.addDisabled(name)
      return
    }

    reporter.report(name) { reporter in
      cases.forEach {
        runBefores()
        $0.run(reporter: reporter)
        runAfters()
      }
    }
  }
}
