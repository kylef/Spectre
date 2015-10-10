# Spectre

[![Build Status](http://img.shields.io/travis/kylef/Spectre/master.svg?style=flat)](https://travis-ci.org/kylef/Spectre)

BDD Framework for Swift

## Usage

```swift
describe("a person") {
  let person = Person(name: "Kyle")

  $0.it("has a name") {
    try equal(person.name, "Kyle")
  }

  $0.it("returns the name as description") {
    try equal(person.description, "Kyle")
  }
}
```

### Reporters

Spectre currently has two built-in reporters, Standard and the Dot reporter.
Custom reporters are supported, simply make a type that conforms to `Reporter`.

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

### Assertions

Spectre doesn't have many assertions at the moment, we're working on finalising
the syntax and then we will add more.

#### `equal`

Assert two types are equal.

```swift
try equal(name, "Kyle")
```

#### `notEqual`

Assert two types are not equal.

```swift
try notEqual(name, "Kyle")
```

#### Causing a failure

```swift
try fail("Everything is broken.")
```

#### Custom assertions

You can easily provide your own assertions, you just need to call `fail` on
a failure.

## Installation / Running

### Conche

[Conche](https://github.com/kylef/Conche) build system has integrated support
for Spectre. You can simply add a `test_spec` to your Conche podspec depending
on Spectre and it will run your tests with `conche test`.

### Manually

You can build Spectre as a Framework or a library and link against it.

For example, if you clone Spectre and run `make` it will build a library you
can link against:

```shell
$ swiftc -I .conche/modules -L .conche/lib -lSpectre -o runner myTests.swift
$ ./runner
```

