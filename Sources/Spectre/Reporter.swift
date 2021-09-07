public protocol Reporter {
  /// Create a new report
  func report(closure: (ContextReporter) -> Void) -> Bool
  func report(closure: (ContextReporter) async -> Void) async -> Bool
}

public protocol ContextReporter {
  func report(_ name: String, closure: (ContextReporter) -> Void)
  func report(_ name: String, closure: (ContextReporter) async -> Void) async

  /// Add a passing test case
  func addSuccess(_ name: String)

  /// Add a disabled test case
  func addDisabled(_ name: String)

  /// Adds a failing test case
  func addFailure(_ name: String, failure: FailureType)
}
