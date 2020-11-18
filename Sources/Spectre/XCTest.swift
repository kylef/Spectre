import XCTest


extension XCTestCase {
  public func describe(_ name: String, _ closure: (ContextType) -> Void) {
    let context = Context(name: name)
    closure(context)
    context.run(reporter: XcodeReporter(testCase: self))
  }

  public func it(_ name: String, closure: @escaping () throws -> Void) {
    let `case` = Case(name: name, closure: closure)
    `case`.run(reporter: XcodeReporter(testCase: self))
  }
}


class XcodeReporter: ContextReporter {
  let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  func report(_ name: String, closure: (ContextReporter) -> Void) {
    closure(self)
  }

  func addSuccess(_ name: String)  {}

  func addDisabled(_ name: String) {}

  func addFailure(_ name: String, failure: FailureType) {
    // Xcode 12 removed `recordFailure` and replaced with `record(_:)`
    #if swift(>=4.2)
    // The `compiler` statement was added in swift 4.2, so it needs to be in a separate statement to retain
    // compatibility with 4.x.
    #if compiler(>=5.3) && os(macOS)
    let location = XCTSourceCodeLocation(filePath: failure.file, lineNumber: failure.line)
    #if Xcode
    // As of Xcode 12.0.1, XCTIssue is unavailable even though it is documented:
    //   https://developer.apple.com/documentation/xctest/xctissue
    // When building with `swift build`, it is available. Perhaps the xctest overlay behaves differently between the two.
    let issue = XCTIssueReference(type: .assertionFailure, compactDescription: "\(name): \(failure.reason)", detailedDescription: nil, sourceCodeContext: .init(location: location), associatedError: nil, attachments: [])
    #else
    let issue = XCTIssue(type: .assertionFailure, compactDescription: "\(name): \(failure.reason)", detailedDescription: nil, sourceCodeContext: .init(location: location), associatedError: nil, attachments: [])
    #endif
    testCase.record(issue)
    #else
    testCase.recordFailure(withDescription: "\(name): \(failure.reason)", inFile: failure.file, atLine: failure.line, expected: false)
    #endif
    #endif
  }
}
