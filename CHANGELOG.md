# Spectre Changelog

## 0.9.0 (2018-09-10)

### Breaking

- Using Spectre in Xcode has be re-hauled, there are now `describe` and `it`
  methods on `XCTestCase` which can be used. When used, these tests will be ran
  directly and reported as XCTest failures and therefore shown in Xcode and
  Xcode sidebar as XCTest failures.

  Use of the global test context, i.e, global `describe` and `it` is no longer
  permitted when using Spectre with XCTest.

### Enhancements

- Adds support for Swift 4.2.

- Unhandled errors will now be reported from the invoked cases source map.

## 0.8.0

Switches to Swift 4.0.

## 0.7.2

## Enhancements

- Adds support for future Swift development snapshots (2016-11-11).


## 0.7.1

## Enhancements

- A test iteration can be skipped by using `skip`.

  ```swift
  throw skip()
  ```


## 0.7.0

This release adds support for Swift 3.0.
