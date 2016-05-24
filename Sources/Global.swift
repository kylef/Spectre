#if os(Linux)
import Glibc
#else
import Darwin
#endif


let globalContext: GlobalContext = {
  atexit { run() }
  return GlobalContext()
}()

public func describe(_ name: String, closure: (ContextType) -> Void) {
  globalContext.describe(name, closure: closure)
}

public func it(_ name: String, closure: () throws -> Void) {
  globalContext.it(name, closure: closure)
}

@noreturn public func run() {
  let reporter: Reporter
  
  if Process.arguments.contains("--tap") {
    reporter = TapReporter()
  } else if Process.arguments.contains("-t") {
    reporter = DotReporter()
  } else {
    reporter = StandardReporter()
  }
  
  run(reporter: reporter)
}

@noreturn public func run(reporter: Reporter) {
  if globalContext.run(reporter: reporter) {
    exit(0)
  }
  exit(1)
}
