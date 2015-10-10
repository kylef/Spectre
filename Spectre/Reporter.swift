public protocol Reporter {
  func report(@noescape closure:ContextReporter -> ()) -> Bool
}

public protocol ContextReporter {
  func report(name:String, @noescape closure:ContextReporter -> ())

  func addSuccess(name:String)
  func addFailure(name:String, failure: Failure)
}

