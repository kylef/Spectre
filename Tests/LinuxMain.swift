import Spectre
import SpectreTests

describe("Expectation", testExpectation)
describe("Failure", testFailure)
describe("Async", testAsync)

//https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md#launching-async-tasks
//"Additionally, top-level code is not considered an asynchronous context in this proposal, so the following program is ill-formed"
// seems no way this can work.
@main
struct Main {
  static func main() async {
    await run()
  }
}
