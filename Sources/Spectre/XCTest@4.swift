#if os(macOS) || os(iOS) || os(tvOS)
import XCTest


extension XcodeReporter {
  func addFailure(_ name: String, failure: FailureType) {
    testCase.recordFailure(withDescription: "\(name): \(failure.reason)", inFile: failure.file, atLine: failure.line, expected: false)
  }
}
#endif
