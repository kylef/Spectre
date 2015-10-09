protocol CaseType {
  func run(reporter:ContextReporter)
}

class Case : CaseType {
  let name:String
  let closure:() throws -> ()

  init(name:String, closure:() throws -> ()) {
    self.name = name
    self.closure = closure
  }

  func run(reporter:ContextReporter) {
    do {
      try closure()
      reporter.addSuccess(name)
    } catch let error as Failure {
      reporter.addFailure(name, failure: error)
    } catch {
      reporter.addFailure(name, failure: Failure(reason: "Unhandled error: \(error)"))
    }
  }
}

