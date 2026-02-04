"""Pretty printer for Mojo structs - inspired by Python's pprint module.

This package provides utilities for pretty-printing Mojo structs with
configurable formatting options. It uses compile-time reflection to
automatically format struct fields without requiring manual implementation.

## Example

```mojo
from pprint import pprint, pformat, PrettyPrinter

struct Person:
    var name: String
    var age: Int

fn main():
    var p = Person("Alice", 30)

    # Print to stdout
    pprint(p)
    # Output:
    # {
    #   name: "Alice",
    #   age: 30
    # }

    # Get as string
    var s = pformat(p)

    # Custom configuration
    var pp = PrettyPrinter(indent=4, show_types=True)
    pprint(p, pp)
```

## Supported Types

- **String** - quoted with double quotes
- **Int** - numeric representation
- **Bool** - lowercase true/false (JSON-style)
- **Float64, Float32, Float16** - decimal representation
- **Nested structs** - recursive formatting with indentation

## Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `indent` | 2 | Spaces per indentation level |
| `max_depth` | 6 | Maximum nesting depth before "..." |
| `max_items` | 64 | Maximum fields shown per struct |
| `show_types` | False | Append type annotations like `<Int>` |
| `compact` | False | Reserved for future single-line output |
"""

from .core import PrettyPrinter, pprint, pformat
