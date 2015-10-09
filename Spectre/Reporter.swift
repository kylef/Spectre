public protocol Reporter {
  func report(@noescape closure:ContextReporter -> ()) -> Bool
}

public protocol ContextReporter {
  func report(name:String, @noescape closure:ContextReporter -> ())

  func addSuccess(name:String)
  func addFailure(name:String, failure: Failure)
}

enum ANSI : String, CustomStringConvertible {
  case Red = "\u{001B}[0;31m"
  case Green = "\u{001B}[0;32m"
  case Yellow = "\u{001B}[0;33m"

  case Bold = "\u{001B}[0;1m"
  case Reset = "\u{001B}[0;0m"

  var description:String {
    return rawValue
  }
}

struct CaseFailure {
  let position: [String]
  let failure: Failure

  init(position: [String], failure: Failure) {
    self.position = position
    self.failure = failure
  }
}

class StandardReporter : Reporter, ContextReporter {
  var depth = 0
  var successes = 0
  var position = [String]()
  var failures = [CaseFailure]()

  func report(@noescape closure:ContextReporter -> ()) -> Bool {
    closure(self)

    for failure in failures {
      let name = failure.position.joinWithSeparator(" ")
      colour(.Red, name)
      let file = "\(failure.failure.file):\(failure.failure.line)"
      print("  \(ANSI.Bold)\(file)\(ANSI.Reset) \(ANSI.Yellow)\(failure.failure.reason)\(ANSI.Reset)\n")
    }

    print("\(successes) passes and \(failures.count) failures")
    return failures.isEmpty
  }

  func report(name:String, @noescape closure:ContextReporter -> ()) {
    colour(.Bold, "-> \(name)")
    ++depth
    position.append(name)
    closure(self)
    --depth
    position.removeLast()
    print("")
  }

  func addSuccess(name:String) {
    ++successes
    colour(.Green, "-> \(name)")
  }

  func addFailure(name:String, failure: Failure) {
    colour(.Red, "-> \(name)")
    failures.append(CaseFailure(position: position + [name], failure: failure))
  }

  func colour(colour:ANSI, _ message:String) {
    let indentation = String(count: depth * 2, repeatedValue: " " as Character)
    print("\(indentation)\(colour)\(message)\(ANSI.Reset)")
  }
}

