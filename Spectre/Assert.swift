public func fail(reason:String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  throw Failure(reason: reason, function: function, file: file, line: line)
}

public func equal<T : Equatable>(lhs:T, _ rhs:T, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  if lhs != rhs {
    try fail("\(lhs) is not equal to \(rhs)", function: function, file: file, line: line)
  }
}

public func notEqual<T : Equatable>(lhs:T, _ rhs:T, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  if lhs == rhs {
    try fail("\(lhs) is equal to \(rhs)", function: function, file: file, line: line)
  }
}

