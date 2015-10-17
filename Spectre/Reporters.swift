import Darwin

enum ANSI : String, CustomStringConvertible {
  case Red = "\u{001B}[0;31m"
  case Green = "\u{001B}[0;32m"
  case Yellow = "\u{001B}[0;33m"

  case Bold = "\u{001B}[0;1m"
  case Reset = "\u{001B}[0;0m"

  var description:String {
    if isatty(STDOUT_FILENO) > 0 {
      return rawValue
    }

    return ""
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

extension CollectionType where Generator.Element == CaseFailure {
  func print() {
    for failure in self {
      let name = failure.position.joinWithSeparator(" ")
      Swift.print(ANSI.Red, name)
      let file = "\(failure.failure.file):\(failure.failure.line)"
      Swift.print("  \(ANSI.Bold)\(file)\(ANSI.Reset) \(ANSI.Yellow)\(failure.failure.reason)\(ANSI.Reset)\n")
    }
  }
}

class CountReporter : Reporter, ContextReporter {
  var depth = 0
  var successes = 0
  var position = [String]()
  var failures = [CaseFailure]()

  func printStatus() {
    failures.print()

    if failures.count == 1 {
      print("\(successes) passes and \(failures.count) failure")
    } else {
      print("\(successes) passes and \(failures.count) failures")
    }
  }

  func report(@noescape closure: ContextReporter -> ()) -> Bool {
    closure(self)
    printStatus()
    return failures.isEmpty
  }

  func report(name: String, @noescape closure: ContextReporter -> ()) {
    ++depth
    position.append(name)
    closure(self)
    --depth
    position.removeLast()
  }

  func addSuccess(name: String) {
    ++successes
  }

  func addFailure(name: String, failure: Failure) {
    failures.append(CaseFailure(position: position + [name], failure: failure))
  }
}

class StandardReporter : CountReporter {
  override func report(name: String, @noescape closure: ContextReporter -> ()) {
    colour(.Bold, "-> \(name)")
    super.report(name, closure: closure)
    print("")
  }

  override func addSuccess(name: String) {
    super.addSuccess(name)
    colour(.Green, "-> \(name)")
  }

  override func addFailure(name: String, failure: Failure) {
    super.addFailure(name, failure: failure)
    colour(.Red, "-> \(name)")
  }

  func colour(colour: ANSI, _ message: String) {
    let indentation = String(count: depth * 2, repeatedValue: " " as Character)
    print("\(indentation)\(colour)\(message)\(ANSI.Reset)")
  }
}

class DotReporter : CountReporter {
  override func addSuccess(name: String) {
    super.addSuccess(name)
    print(ANSI.Green, ".", ANSI.Reset, separator: "", terminator: "")
  }

  override func addFailure(name: String, failure: Failure) {
    super.addFailure(name, failure: failure)
    print(ANSI.Red, "F", ANSI.Reset, separator: "", terminator: "")
  }

  override func printStatus() {
    print("\n")
    super.printStatus()
  }
}
