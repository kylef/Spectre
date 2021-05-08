// PathKit - Effortless path operations

import Foundation

/// Represents a filesystem path.
struct Path {
  /// The character used by the OS to separate two path elements
  static let separator = "/"

  /// The underlying string representation
  internal let path: String
  internal static let fileManager = FileManager.default

  // MARK: Init

  init() {
    self.init("")
  }

  /// Create a Path from a given String
  init(_ path: String) {
    self.path = path
  }

  /// Create a Path by joining multiple path components together
  init<S : Collection>(components: S) where S.Iterator.Element == String {
    let path: String
    if components.isEmpty {
      path = "."
    } else if components.first == Path.separator && components.count > 1 {
      let p = components.joined(separator: Path.separator)
      path = String(p[p.index(after: p.startIndex)...])
    } else {
      path = components.joined(separator: Path.separator)
    }
    self.init(path)
  }
}



// MARK: Conversion

extension Path {
  var string: String {
    return self.path
  }

  var url: URL {
    return URL(fileURLWithPath: path)
  }
}


// MARK: Hashable

extension Path : Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.path.hashValue)
  }
}


// MARK: Path Info

extension Path {
  /// Test whether a path is absolute.
  ///
  /// - Returns: `true` iff the path begins with a slash
  ///
  public var isAbsolute: Bool {
    return path.hasPrefix(Path.separator)
  }

  /// Test whether a path is absolute.
  ///
  /// - Returns: `true` iff the path begins with a slash
  ///
  var isRelative: Bool {
    return !isAbsolute
  }

  /// Concatenates relative paths to the current directory and derives the normalized path
  ///
  /// - Returns: the absolute path in the actual filesystem
  ///
  func absolute() -> Path {
    if isAbsolute {
      return normalize()
    }

    let expandedPath = Path(NSString(string: self.path).expandingTildeInPath)
    if expandedPath.isAbsolute {
      return expandedPath.normalize()
    }

    return (Path.current + self).normalize()
  }

  /// Normalizes the path, this cleans up redundant ".." and ".", double slashes
  /// and resolves "~".
  ///
  /// - Returns: a new path made by removing extraneous path components from the underlying String
  ///   representation.
  ///
  func normalize() -> Path {
    return Path(NSString(string: self.path).standardizingPath)
  }
}

// MARK: Current Directory

extension Path {
  /// The current working directory of the process
  ///
  /// - Returns: the current working directory of the process
  ///
  static var current: Path {
    get {
      return self.init(Path.fileManager.currentDirectoryPath)
    }
  }
}


// MARK: Equatable

extension Path : Equatable {}

/// Determines if two paths are identical
///
/// - Note: The comparison is string-based. Be aware that two different paths (foo.txt and
///   ./foo.txt) can refer to the same file.
///
func ==(lhs: Path, rhs: Path) -> Bool {
  return lhs.path == rhs.path
}


// MARK: Pattern Matching

/// Implements pattern-matching for paths.
///
/// - Returns: `true` iff one of the following conditions is true:
///     - the paths are equal (based on `Path`'s `Equatable` implementation)
///     - the paths can be normalized to equal Paths.
///
func ~=(lhs: Path, rhs: Path) -> Bool {
  return lhs == rhs
    || lhs.normalize() == rhs.normalize()
}

// MARK: Operators

/// Appends a Path fragment to another Path to produce a new Path
func +(lhs: Path, rhs: Path) -> Path {
  return lhs.path + rhs.path
}

/// Appends a String fragment to another Path to produce a new Path
func +(lhs: Path, rhs: String) -> Path {
  return lhs.path + rhs
}

/// Appends a String fragment to another String to produce a new Path
internal func +(lhs: String, rhs: String) -> Path {
  if rhs.hasPrefix(Path.separator) {
    // Absolute paths replace relative paths
    return Path(rhs)
  } else {
    var lSlice = NSString(string: lhs).pathComponents.fullSlice
    var rSlice = NSString(string: rhs).pathComponents.fullSlice

    // Get rid of trailing "/" at the left side
    if lSlice.count > 1 && lSlice.last == Path.separator {
      lSlice.removeLast()
    }

    // Advance after the first relevant "."
    lSlice = lSlice.filter { $0 != "." }.fullSlice
    rSlice = rSlice.filter { $0 != "." }.fullSlice

    // Eats up trailing components of the left and leading ".." of the right side
    while lSlice.last != ".." && !lSlice.isEmpty && rSlice.first == ".." {
      if lSlice.count > 1 || lSlice.first != Path.separator {
        // A leading "/" is never popped
        lSlice.removeLast()
      }
      if !rSlice.isEmpty {
        rSlice.removeFirst()
      }

      switch (lSlice.isEmpty, rSlice.isEmpty) {
      case (true, _):
        break
      case (_, true):
        break
      default:
        continue
      }
    }

    return Path(components: lSlice + rSlice)
  }
}

extension Array {
  var fullSlice: ArraySlice<Element> {
    return self[self.indices.suffix(from: 0)]
  }
}
