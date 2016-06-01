public protocol Reporter {
  /// Create a new report
#if swift(>=3.0)
  func report(closure: @noescape (ContextReporter) -> Void) -> Bool
#else
  func report(@noescape closure: (ContextReporter) -> Void) -> Bool
#endif
}

public protocol ContextReporter {
#if swift(>=3.0)
  func report(_ name: String, closure: @noescape (ContextReporter) -> Void)
#else
  func report(_ name: String, @noescape closure: (ContextReporter) -> Void)
#endif

  /// Add a passing test case
  func addSuccess(_ name: String)

  /// Add a disabled test case
  func addDisabled(_ name: String)

  /// Adds a failing test case
  func addFailure(_ name: String, failure: FailureType)
}
