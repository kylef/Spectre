#if os(macOS) || os(iOS) || os(tvOS)
import XCTest


extension XcodeReporter {
  func addFailure(_ name: String, failure: FailureType) {
    // Xcode 12 removed `recordFailure` and replaced with `record(_:)`
#if compiler(>=5.3)
    let location = XCTSourceCodeLocation(filePath: failure.file, lineNumber: failure.line)
    let issue = XCTIssue(type: .assertionFailure, compactDescription: "\(name): \(failure.reason)", detailedDescription: nil, sourceCodeContext: .init(location: location), associatedError: nil, attachments: [])
    testCase.record(issue)
#else
    testCase.recordFailure(withDescription: "\(name): \(failure.reason)", inFile: failure.file, atLine: failure.line, expected: false)
#endif
  }
}
#endif
