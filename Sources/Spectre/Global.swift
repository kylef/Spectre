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


@discardableResult func disableUnmatchedPaths(_ paths: [Path], _ `case`: CaseType) -> Bool {
  if let `case` = `case` as? Case {
    if !`case`.disabled {
      let path = Path(`case`.file)

      if !(paths.contains(where: { $0 ~= path })) {
        `case`.disabled = true
      }
    }
    return !`case`.disabled
  } else if let context = `case` as? Context {
    var containsMatch = false
    for `case` in context.cases {
      if disableUnmatchedPaths(paths, `case`) {
        containsMatch = true
      }
    }

    if !containsMatch {
      context.disabled = true
    }

    return containsMatch
  } else {
    let error = "Unexpected type on global context (report as bug)\n"
    FileHandle.standardError.write(error.data(using: .utf8)!)
    exit(3)
  }
}


public func run() -> Never  {
  var reporter = defaultReporter()
  var paths: [Path] = []

  var arguments: [String] = Array(CommandLine.arguments[1...])
  if let addOptions = ProcessInfo.processInfo.environment["SPECTRE_ADDOPTS"] {
    arguments += addOptions.split(separator: " ").map(String.init)
  }

  for argument in arguments {
    if argument == "--tap" {
      reporter = TapReporter()
    } else if argument == "-t" {
      reporter = DotReporter()
    } else if argument.hasPrefix("-") {
      let error = "Unexpected option: \(argument)\n"
      FileHandle.standardError.write(error.data(using: .utf8)!)
      exit(4)
    } else {
      let path = Path(argument)
      paths.append(path.absolute())
    }
  }

  // filter by paths
  if !paths.isEmpty {
    for `case` in globalContext.cases {
      disableUnmatchedPaths(paths, `case`)
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
