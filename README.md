# pprint

[![CI](https://github.com/ehsanmok/pprint/actions/workflows/ci.yaml/badge.svg)](https://github.com/ehsanmok/pprint/actions/workflows/ci.yaml)
[![Docs](https://github.com/ehsanmok/pprint/actions/workflows/docs.yaml/badge.svg)](https://ehsanmok.github.io/pprint/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Reflection-driven pretty printer for Mojo structs.

## Why pprint?

Mojo's built-in `print()` requires types to implement the `Writable` trait:

```mojo
@fieldwise_init
struct Person(Copyable, Movable):
    var name: String
    var age: Int

def main():
    var p = Person("Ada", 36)
    print(p)  # ERROR: 'Person' does not implement 'Writable'
```

With `pprint`, no trait implementation is required. It uses reflection to inspect and format any struct automatically:

```mojo
from pprint import pprint

def main():
    var p = Person("Ada", 36)
    pprint(p)  # Works! No Writable needed
```

## Quick Start

```mojo
from pprint import pprint, PrettyPrinter

@fieldwise_init
struct Person(Copyable, Movable):
    var name: String
    var age: Int

def main():
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

## Installation

Add pprint to your project's `pixi.toml`:

```toml
[workspace]
channels = ["https://conda.modular.com/max-nightly", "conda-forge"]
preview = ["pixi-build"]

[dependencies]
pprint = { git = "https://github.com/ehsanmok/pprint.git", tag = "v0.1.0" }
```

Then run:

```bash
pixi install
```

Requires [pixi](https://pixi.sh) (pulls Mojo nightly automatically).

For the latest development version:

```toml
[dependencies]
pprint = { git = "https://github.com/ehsanmok/pprint.git", branch = "main" }
```

## Features

- **Zero boilerplate**: Works on any struct without implementing traits
- **Configurable**: Custom indentation, depth limits, item limits
- **Type annotations**: Optional `show_types` mode
- **JSON-style output**: Booleans as `true`/`false`, strings quoted

Full API reference: [ehsanmok.github.io/pprint](https://ehsanmok.github.io/pprint/)

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
