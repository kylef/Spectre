#if swift(>=3.0)
func printFailures(_ failures: [CaseFailure]) {
  printFailures(failures: failures)
}
#else
public typealias ErrorProtocol = ErrorType
public typealias Collection = CollectionType

extension SequenceType where Generator.Element == String {
  func joined(separator separator: String) -> String {
    return joinWithSeparator(separator)
  }
}

public func failure(reason reason: String? = nil, function: String = #function, file: String = #file, line: Int = #line) -> FailureType {
  return Failure(reason: reason ?? "-", function: function, file: file, line: line)
}

extension ExpectationType {
  func failure(reason reason: String) -> FailureType {
    return failure(reason)
  }
}

extension GlobalContext {
  func run(reporter reporter: Reporter) -> Bool {
    return run(reporter)
  }
}

extension CaseType {
  func run(reporter reporter: ContextReporter) {
    run(reporter)
  }
}
#endif
