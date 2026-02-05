"""Reflection-driven pretty printer for Mojo structs.

- **Zero boilerplate** — Works on any struct without implementing traits
- **Configurable** — Custom indentation, depth limits, item limits
- **Type annotations** — Optional `show_types` mode
- **JSON-style output** — Booleans as `true`/`false`, strings quoted

## Why pprint?

Mojo's built-in `print()` requires types to implement the `Writable` trait:

```mojo
@fieldwise_init
struct Person(Copyable, Movable):
    var name: String
    var age: Int

fn main():
    var p = Person("Ada", 36)
    print(p)  # ERROR: 'Person' does not implement 'Writable'
```

With `pprint`, no trait implementation is required - it uses reflection to
inspect and format any struct automatically:

```mojo
from pprint import pprint

fn main():
    var p = Person("Ada", 36)
    pprint(p)  # Works! No Writable needed
```

## Requirements

[pixi](https://pixi.sh) package manager

## Installation

Add pprint to your project's `pixi.toml`:

```toml
[workspace]
channels = ["https://conda.modular.com/max-nightly", "conda-forge"]
preview = ["pixi-build"]

[dependencies]
pprint = { git = "https://github.com/ehsanmok/pprint.git" }
```

Then run:

```
pixi install
```

## Quick Start

```mojo
from pprint import pprint, PrettyPrinter

@fieldwise_init
struct Person(Copyable, Movable):
    var name: String
    var age: Int

fn main():
    var p = Person("Ada", 36)
    pprint(p)
```

Output:

```
{
  name: "Ada",
  age: 36
}
```

## API Reference

### pprint() - Print to stdout

Print any value to stdout with pretty formatting. Like Python's `pprint.pprint`.

```mojo
from pprint import pprint, PrettyPrinter

# Default formatting
pprint(my_struct)

# With custom configuration
var pp = PrettyPrinter(indent=4, show_types=True)
pprint(my_struct, pp)
```

### pformat() - Format as String

Return a pretty-formatted string instead of printing. Like Python's `pprint.pformat`.
Useful for logging, string concatenation, or storing formatted output.

```mojo
from pprint import pformat, PrettyPrinter

# Get formatted string
var s = pformat(my_struct)
print("Debug: " + s)

# With custom configuration
var pp = PrettyPrinter(indent=4)
var s = pformat(my_struct, pp)
```

### PrettyPrinter - Configuration

All formatting options are controlled through `PrettyPrinter`:

```mojo
var pp = PrettyPrinter(
    indent=2,         # Spaces per indent level (default: 2)
    max_depth=6,      # Max nesting depth before "..." (default: 6)
    max_items=64,     # Max fields shown before "..." (default: 64)
    show_types=False, # Show type annotations (default: False)
    compact=False,    # Reserved for future use
)
```

| Option | Default | Description |
|--------|---------|-------------|
| `indent` | 2 | Spaces per indentation level |
| `max_depth` | 6 | Maximum nesting depth before "..." |
| `max_items` | 64 | Maximum fields shown per struct |
| `show_types` | False | Append type annotations like `<Int>` |
| `compact` | False | Reserved for future single-line output |

### Supported Types

| Type | Output Format | Example |
|------|---------------|---------|
| `String` | Quoted with double quotes | `"Ada"` |
| `Int` | Numeric | `42`, `-10`, `0` |
| `Bool` | Lowercase JSON-style | `true`, `false` |
| `Float64` | Decimal | `3.14`, `95.5` |
| `Float32` | Decimal | `1.5` |
| `Float16` | Decimal | `0.5` |
| Nested structs | Recursive with braces | `{ inner: { ... } }` |
| Empty structs | Empty braces | `{}` |
| Unknown types | Placeholder | `<unknown>` |

## Examples

### Scalars

`pprint` and `pformat` work directly on scalar values:

```mojo
from pprint import pformat

print(pformat(42))            # 42
print(pformat(True))          # true
print(pformat(3.14))          # 3.14
print(pformat("hello world")) # "hello world"
```

### Nested Structs

Nested structs are formatted recursively with proper indentation:

```mojo
from pprint import pprint

@fieldwise_init
struct Address(Copyable, Movable):
    var city: String
    var zip: Int

@fieldwise_init
struct Person(Copyable, Movable):
    var name: String
    var age: Int
    var active: Bool
    var score: Float64
    var address: Address

fn main():
    var p = Person("Ada", 36, True, 95.5, Address("London", 12345))
    pprint(p)
```

Output:

```
{
  name: "Ada",
  age: 36,
  active: true,
  score: 95.5,
  address: {
    city: "London",
    zip: 12345
  }
}
```

### Type Annotations

Enable `show_types=True` to see type information after each value:

```mojo
from pprint import pprint, PrettyPrinter

var pp = PrettyPrinter(show_types=True)
pprint(my_struct, pp)
```

Output:

```
{
  name: "Ada" <String>,
  age: 36 <Int>,
  active: true <Bool>,
  score: 95.5 <Float64>,
  address: {
    city: "London" <String>,
    zip: 12345 <Int>
  } <Address>
}
```

### Custom Indentation

Control indent width for different readability needs:

```mojo
from pprint import pprint, PrettyPrinter

# 4-space indent
pprint(my_struct, PrettyPrinter(indent=4))

# Minimal indent
pprint(my_struct, PrettyPrinter(indent=1))
```

### Depth Limiting

Prevent overly deep output for complex nested structures:

```mojo
from pprint import pprint, PrettyPrinter

# Truncate at depth 2 (shows "..." for deeper levels)
pprint(deeply_nested, PrettyPrinter(max_depth=2))
```

Output:

```
{
  inner: {
    inner: ...
  }
}
```

### Field Limiting

Limit the number of fields shown for structs with many fields:

```mojo
from pprint import pprint, PrettyPrinter

# Show only first 3 fields, then "..."
pprint(large_struct, PrettyPrinter(max_items=3))
```

### Using pformat for Logging

```mojo
from pprint import pformat

fn log_state[T: AnyType](label: String, value: T):
    print("[LOG] " + label + ": " + pformat(value))

fn main():
    var config = AppConfig(...)
    log_state("startup config", config)
```
"""

from .core import PrettyPrinter, pprint, pformat
