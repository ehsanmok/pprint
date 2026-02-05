# pprint

[![CI](https://github.com/ehsanmok/pprint/actions/workflows/ci.yaml/badge.svg)](https://github.com/ehsanmok/pprint/actions/workflows/ci.yaml)
[![API Docs](https://img.shields.io/badge/docs-API-blue)](https://ehsanmok.github.io/pprint/pprint/)

Reflection-driven pretty printer for Mojo structs.

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

With `pprint`, **no trait implementation is required** - it uses reflection to inspect and format any struct automatically:

```mojo
from pprint import pprint

fn main():
    var p = Person("Ada", 36)
    pprint(p)  # Works! No Writable needed
```

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

```bash
pixi install
```

## Features

- **Zero boilerplate**: Works on any struct without implementing traits
- **Configurable**: Custom indentation, depth limits, item limits
- **Type annotations**: Optional `show_types` mode
- **JSON-style output**: Booleans as `true`/`false`, strings quoted

## Quick Start

```mojo
from pprint import pprint, PrettyPrinter

@fieldwise_init
struct Person(Copyable, Movable):
    var name: String
    var age: Int

fn main():
    var p = Person("Ada", 36)
    pprint(p)  # Prints to stdout
```

Output:

```
{
  name: "Ada",
  age: 36
}
```

## API

```mojo
# Print to stdout (like Python's pprint.pprint)
pprint(value)
pprint(value, pp)

# Return formatted string (like Python's pprint.pformat)
var s = pformat(value)
var s = pformat(value, pp)
```

## PrettyPrinter Options

```mojo
var pp = PrettyPrinter(
    indent=2,         # Spaces per indent level (default: 2)
    max_depth=6,      # Max nesting depth before "..." (default: 6)
    max_items=64,     # Max fields shown before "..." (default: 64)
    show_types=False, # Show type annotations (default: False)
    compact=False,    # Reserved for future use
)
```

With `show_types=True`:

```
{
  name: "Ada" <String>,
  age: 36 <Int>
}
```

## Development

To contribute or run tests:

```bash
git clone https://github.com/ehsanmok/pprint.git && cd pprint
pixi install
pixi run tests
```

### Tasks

```bash
pixi run tests       # Run test suite
pixi run example     # Run example
pixi run format      # Format code
pixi run docs        # Generate docs and open in browser
pixi run docs-build  # Generate docs to target/doc/
```

## License

[MIT](./LICENSE)

