# Spectre

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

##### Green

![](Screenshots/Success.png)

##### Failing Tests

![](Screenshots/Failure.png)

### Assertions

#### `equal`

Assert two types are equal.

```
try equal(name, "Kyle")
```

#### `notEqual`

Assert two types are not equal.

```
try notEqual(name, "Kyle")
```

#### Causing a failure

```
try fail("Everything is broken.")
```

#### Custom assertions

You can easily provide your own assertions, you just need to call `fail` on
a failure.

### Reporters

Spectre currently has one standard reporter. There is an API to build your own
if you would like to. Just create a type that conforms to `Reporter` and pass
it to the `run` function.

## Installation

Installation is not yet advised.

