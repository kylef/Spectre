public protocol FailureType : ErrorProtocol {
  var function: String { get }
  var file: String { get }
  var line: Int { get }

  var reason: String { get }
}

struct Failure : FailureType {
  let reason: String

  let function: String
  let file: String
  let line: Int

  init(reason: String, function: String = #function, file: String = #file, line: Int = #line) {
    self.reason = reason
    self.function = function
    self.file = file
    self.line = line
  }
}


public func failure(reason: String? = nil, function: String = #function, file: String = #file, line: Int = #line) -> FailureType {
  return Failure(reason: reason ?? "-", function: function, file: file, line: line)
}
