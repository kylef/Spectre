#if os(macOS)
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
    if #available(OSX 10.13, *) {
        //This line should be replaced to XCTestCase.record(_:) on Xcode12+
        //https://developer.apple.com/documentation/xctest/xctestcase/3546549-record
        testCase.recordFailure(withDescription: "\(name): \(failure.reason)", inFile: failure.file, atLine: failure.line, expected: false)
    }
  }
}
#endif
