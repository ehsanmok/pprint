"""Pretty printer for Mojo structs - inspired by Python's pprint module.

This package provides utilities for pretty-printing Mojo structs with
configurable formatting options. It uses compile-time reflection to
automatically format struct fields without requiring manual implementation.

Example:
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

Supported types:
    - String (quoted)
    - Int
    - Bool (lowercase true/false)
    - Float64, Float32, Float16
    - Nested structs (recursive formatting)

Configuration options:
    - indent: Number of spaces per indentation level (default: 2)
    - max_depth: Maximum nesting depth before showing "..." (default: 6)
    - max_items: Maximum fields to show per struct (default: 64)
    - show_types: Append type annotations like "<Int>" (default: False)
    - compact: Reserved for future single-line output (default: False)
"""

from .core import PrettyPrinter, pprint, pformat
