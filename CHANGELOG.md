# Spectre Changelog

## 0.10.0 (2021-05-15)

### Breaking Changes

- Support for Swift < 4.2 has been dropped.

### Enhancements

- Reporter type can be set via an environment variable. For example, to use dot
  reporter:

  ```shell
  $ env SPECTRE_REPORTER=dot swift test
  ```

- Additional arguments and options can be passed to Spectre using the
  `SPECTRE_ADDOPTS` environment variable, for example:

  ```shell
  $ SPECTRE_ADDOPTS=Tests/SpectreTests/FailureSpec.swift swift test
  ```

- Spectre can be passed a set of files to filter which tests will be executed.

- Add support for Xcode 12.5.

- Added support for building Spectre on Windows.

## 0.9.2 (2020-11-18)

### Enhancements

- Added support for using the XCTest integration on non Apple platforms with
  [swift-corelibs-xctest](https://github.com/apple/swift-corelibs-xctest)

### Bug Fixes

- Compatibility with some versions of Xcode greater than 12.0.1 where a build
  error with incompatibility between XCTIssue and XCTIssueReference may be
  presented with Swift 5.3.

## 0.9.1 (2020-08-16)

### Enhancements

- Added support for using the XcodeReporter with Xcode 12 beta.

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
