protocol CaseType {
  /// Run a test case in the given reporter
  func run(reporter: ContextReporter)
}

class Case : CaseType {
  let name:String
  let disabled: Bool
  let closure:() throws -> ()

  init(name: String, disabled: Bool = false, closure: @escaping () throws -> ()) {
    self.name = name
    self.disabled = disabled
    self.closure = closure
  }

  func run(reporter: ContextReporter) {
    if disabled {
      reporter.addDisabled(name)
      return
    }

    do {
      try closure()
      reporter.addSuccess(name)
    } catch _ as Skip {
      reporter.addDisabled(name)
    } catch let error as FailureType {
      reporter.addFailure(name, failure: error)
    } catch {
      reporter.addFailure(name, failure: Failure(reason: "Unhandled error: \(error)"))
    }
  }
}
