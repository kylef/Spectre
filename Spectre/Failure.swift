public struct Failure : ErrorType {
  let reason:String
  let function:String
  let file:String
  let line:Int

  init(reason:String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    self.reason = reason
    self.function = function
    self.file = file
    self.line = line
  }
}

