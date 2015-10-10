import Darwin

let globalContext: GlobalContext = {
  atexit { run() }
  return GlobalContext()
}()

public func describe(name:String, closure:ContextType -> ()) {
  globalContext.describe(name, closure: closure)
}

public func it(name:String, closure:() throws -> ()) {
  globalContext.it(name, closure: closure)
}

@noreturn public func run() {
  let reporter: Reporter

  if Process.arguments.contains("-t") {
    reporter = DotReporter()
  } else {
    reporter = StandardReporter()
  }

  run(reporter)
}

@noreturn public func run(reporter:Reporter) {
  if globalContext.run(reporter) {
    exit(0)
  }
  exit(1)
}

