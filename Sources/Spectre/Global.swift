#if os(Linux)
import Glibc
#else
import Darwin
#endif


let globalContext: GlobalContext = {
#if os(macOS)
  if getenv("XCTestConfigurationFilePath") != nil {
    fatalError("Use of global context is not permitted when running inside XCTest")
  }
#endif
  atexit { run() }
  return GlobalContext()
}()

public func describe(_ name: String, _ closure: (ContextType) -> Void) {
  globalContext.describe(name, closure: closure)
}

public func it(_ name: String, _ closure: @escaping () throws -> Void) {
  globalContext.it(name, closure: closure)
}

public func run() -> Never  {
  let reporter: Reporter

  if CommandLine.arguments.contains("--tap") {
    reporter = TapReporter()
  } else if CommandLine.arguments.contains("-t") {
    reporter = DotReporter()
  } else {
    reporter = StandardReporter()
  }

  run(reporter: reporter)
}

public func run(reporter: Reporter) -> Never  {
  if globalContext.run(reporter: reporter) {
    exit(0)
  }
  exit(1)
}
