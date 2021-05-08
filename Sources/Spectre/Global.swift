#if os(Linux)
import Glibc
#elseif os(Windows)
import CRT
#else
import Darwin
#endif

import Foundation


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

#if swift(>=4.2)
enum ReporterType: String, CaseIterable {
  case tap
  case dot
}
#endif

fileprivate func defaultReporter() -> Reporter {
  if let reporterEnv = ProcessInfo.processInfo.environment["SPECTRE_REPORTER"] {
#if swift(>=4.2)
    guard let reporterType = ReporterType(rawValue: reporterEnv) else {
      let supported = ReporterType.allCases.map { $0.rawValue }
      let error = "Unknown reporter: \(reporterEnv). Supported: \(supported.joined(separator: ", "))\n"
      FileHandle.standardError.write(error.data(using: .utf8)!)
      exit(4)
    }

    switch reporterType {
    case .tap:
      return TapReporter()
    case .dot:
      return DotReporter()
    }
#else
    let error = "SPECTRE_REPORTER is unsupported on Swift < 4.1\n"
    FileHandle.standardError.write(error.data(using: .utf8)!)
    exit(4)
#endif
  }

  return StandardReporter()
}

public func run() -> Never  {
  var reporter = defaultReporter()

  for argument in CommandLine.arguments[1...] {
    if CommandLine.arguments.contains("--tap") {
      reporter = TapReporter()
    } else if CommandLine.arguments.contains("-t") {
      reporter = DotReporter()
    } else {
      let error = "Unexpected argument: \(argument)\n"
      FileHandle.standardError.write(error.data(using: .utf8) ?? Data())
      exit(4)
    }
  }

  run(reporter: reporter)
}

public func run(reporter: Reporter) -> Never  {
  if globalContext.run(reporter: reporter) {
    exit(0)
  }
  exit(1)
}
