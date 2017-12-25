#if os(Linux)
import Glibc
#else
import Darwin
import XCTest

extension XCTestCase {
  
  class Reporter: StandardReporter {
    
    weak var testCase: XCTestCase?
    
    override func printStatus() {
      // while running with test case do not print status
      // only print it in the very end
      if testCase == nil {
        super.printStatus()
      }
    }
    
    override func report(_ name: String, closure: (ContextReporter) -> Void) {
      if depth == 0 {
        print("")
      }
      super.report(name, closure: closure)
    }
    
    override func addFailure(_ name: String, failure: FailureType) {
      super.addFailure(name, failure: failure)
      print("")

      let name = (position + [name]).joined(separator: " ")
      testCase?.recordFailure(withDescription: "\(name): \(failure.reason)", inFile: failure.file, atLine: failure.line, expected: false)
    }
    
  }
  
  static let reporter = Reporter()
  
  public func describe(_ name: StaticString = #function, _ test: (ContextType) -> Void) {
    XCTestCase.reporter.testCase = self
    defer { XCTestCase.reporter.testCase = nil }
    ANSI.isEnabled = !CommandLine.arguments.contains("--no-colors")

    Spectre.describe(name, closure: test)
    _ = globalContext.run(reporter: XCTestCase.reporter)
    globalContext.cases.removeLast()
  }
  
}

#endif

let globalContext: GlobalContext = {
  atexit { run() }
  return GlobalContext()
}()

public func describe(_ name: StaticString = #function, closure: (ContextType) -> Void) {
  globalContext.describe(String(describing: name), closure: closure)
}

public func it(_ name: String, closure: @escaping () throws -> Void) {
  globalContext.it(name, closure: closure)
}

public func run() -> Never  {
  let reporter: Reporter

  if CommandLine.arguments.contains("--tap") {
    reporter = TapReporter()
  } else if CommandLine.arguments.contains("-t") {
    reporter = DotReporter()
  } else {
    #if os(Linux)
    reporter = StandardReporter()
    #else
    reporter = XCTestCase.reporter
    #endif
  }
  
  ANSI.isEnabled = !CommandLine.arguments.contains("--no-colors")

  run(reporter: reporter)
}

public func run(reporter: Reporter) -> Never  {
  if globalContext.run(reporter: reporter) {
    exit(0)
  }
  exit(1)
}
