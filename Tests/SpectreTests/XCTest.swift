import XCTest
import Spectre

class SpectreTests: XCTestCase {
  func testSpectre() async {
    await describe("Failure", testFailure)
    await describe("Expectation", testExpectation)
    await describe("Async", testAsync)
  }
}
