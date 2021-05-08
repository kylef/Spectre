# Spectre

[![Build Status](https://img.shields.io/travis/kylef/Spectre/master.svg?style=flat)](https://travis-ci.org/kylef/Spectre)

[*Sp*ecial *E*xecutive for *C*ommand-line *T*est *R*unning and
*E*xecution](https://en.wikipedia.org/wiki/SPECTRE).

A behavior-driven development (BDD) framework and test runner for Swift projects
and playgrounds. It's compatible with both OS X and Linux.

## Usage

```swift
describe("a person") {
  let person = Person(name: "Kyle")

  $0.it("has a name") {
    try expect(person.name) == "Kyle"
  }

  $0.it("returns the name as description") {
    try expect(person.description) == "Kyle"
  }
}
```

### Reporters

Spectre currently has two built-in reporters, Standard and the Dot reporter.
Custom reporters are supported, make a type that conforms to `Reporter`.

- Standard
- Dot Reporter (`-t`)
- Tap Reporter (`--tap)` - [Test Anything Protocol](http://testanything.org/)-compatible output

The default reporter can be configured via an environment variable. For
example:

```shell
$ env SPECTRE_REPORTER=dot swift test
$ env SPECTRE_REPORTER=tap swift test
```

#### Standard

The standard reporter produces output as follows:

##### Passing Tests

![Standard Reporter Success](Screenshots/success.png)

##### Failing Tests

![Standard Reporter Failure](Screenshots/failure.png)

#### Dot

Using the `-t` argument, you can use the dot reporter.

##### Passing Tests

![Dot Reporter Success](Screenshots/success-dot.png)

##### Failing Tests

![Dot Reporter Failure](Screenshots/failure-dot.png)

### Expectation

#### Equivalence

```swift
try expect(name) == "Kyle"
try expect(name) != "Kyle"
```

#### Truthiness

```swift
try expect(alive).to.beTrue()
try expect(alive).to.beFalse()
try expect(alive).to.beNil()
```

#### Error handling

```swift
try expect(try write()).toThrow()
try expect(try write()).toThrow(FileError.NoPermission)
```

#### Comparable

```swift
try expect(5) > 2
try expect(5) >= 2
try expect(5) < 10
try expect(5) <= 10
```

#### Types

```swift
try expect("kyle").to.beOfType(String.self)
```

#### Causing a failure

```swift
throw failure("Everything is broken.")
```

#### Custom assertions

You can easily provide your own assertions, you just need to throw a
failure when the assertion does not meet expectaions.

## Examples

The following projects use Spectre:

- [Commander](https://github.com/kylef/Commander)
- [Stencil](https://github.com/stencilproject/Stencil)

## Installation / Running

### Swift Package Manager

Check out [Commander](https://github.com/kylef/Commander) as an example.

### Playground

You can use Spectre in an Xcode Playground, open `Spectre.playground` in
this repository, failures are printed in the console.

![Spectre in an Xcode Playground](Screenshots/Playground.png)
