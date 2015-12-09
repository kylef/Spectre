public protocol Reporter {
  /// Create a new report
  func report(@noescape closure:ContextReporter -> ()) -> Bool
}

public protocol ContextReporter {
  func report(name:String, @noescape closure:ContextReporter -> ())

  /// Add a passing test case
  func addSuccess(name:String)

  /// Add a disabled test case
  func addDisabled(name: String)

  /// Adds a failing test case
  func addFailure(name:String, failure: FailureType)
}
