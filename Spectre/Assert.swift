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
