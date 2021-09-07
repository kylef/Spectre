protocol CaseType {
  /// Run a test case in the given reporter
  func run(reporter: ContextReporter)
}

protocol AsyncCaseType {
  /// Run a test case in the given reporter
  func run(reporter: ContextReporter) async
}

class Case : CaseType {
  let name: String
  var disabled: Bool
  let closure: () throws -> ()

  let function: String
  let file: String
  let line: Int

  init(name: String, disabled: Bool = false, closure: @escaping () throws -> (), function: String = #function, file: String = #file, line: Int = #line) {
    self.name = name
    self.disabled = disabled
    self.closure = closure

    self.function = function
    self.file = file
    self.line = line
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
      reporter.addFailure(name, failure: Failure(reason: "Unhandled error: \(error)", function: function, file: file, line: line))
    }
  }
}


class AsyncCase : AsyncCaseType {
  let name: String
  var disabled: Bool
  let closure: () async throws -> ()

  let function: String
  let file: String
  let line: Int

  init(name: String, disabled: Bool = false, closure: @escaping () async throws -> (), function: String = #function, file: String = #file, line: Int = #line) {
    self.name = name
    self.disabled = disabled
    self.closure = closure

    self.function = function
    self.file = file
    self.line = line
  }

  func run(reporter: ContextReporter) async {
    if disabled {
      reporter.addDisabled(name)
      return
    }

    do {
      try await closure()
      reporter.addSuccess(name)
    } catch _ as Skip {
      reporter.addDisabled(name)
    } catch let error as FailureType {
      reporter.addFailure(name, failure: error)
    } catch {
      reporter.addFailure(name, failure: Failure(reason: "Unhandled error: \(error)", function: function, file: file, line: line))
    }
  }
}
