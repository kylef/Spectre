public protocol Reporter {
  /// Create a new report
  func report(@noescape closure: ContextReporter -> ()) -> Bool
}

public protocol ContextReporter {
  func report(_ name: String, @noescape closure: ContextReporter -> ())

  /// Add a passing test case
  func addSuccess(_ name:String)

  /// Add a disabled test case
  func addDisabled(_ name: String)

  /// Adds a failing test case
  func addFailure(_ name: String, failure: FailureType)
}
