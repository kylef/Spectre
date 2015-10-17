public func failure(reason:String? = nil, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) -> Failure {
  return Failure(reason: reason ?? "-", function: function, file: file, line: line)
}

public func equal<T : Equatable>(lhs:T, _ rhs:T, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  if lhs != rhs {
    throw failure("\(lhs) is not equal to \(rhs)", function: function, file: file, line: line)
  }
}

public func equal<T : Equatable>(lhs:T?, _ rhs:T, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  if let lhs = lhs {
    try equal(lhs, rhs, function: function, file: file, line: line)
  } else {
    throw failure("\(lhs) is not equal to \(rhs)", function: function, file: file, line: line)
  }
}

public func notEqual<T : Equatable>(lhs:T, _ rhs:T, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  if lhs == rhs {
    throw failure("\(lhs) is equal to \(rhs)", function: function, file: file, line: line)
  }
}

public func `nil`<T : Equatable>(lhs:T?, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  if let lhs = lhs {
    throw failure("\(lhs) is not nil", function: function, file: file, line: line)
  }
}

public func notNil<T : Equatable>(lhs:T?, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) throws {
  if lhs == nil {
    throw failure("\(lhs) is nil", function: function, file: file, line: line)
  }
}
