from pprint import PrettyPrinter, pprint, pformat


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
    # Basic usage
    print("=== Basic struct ===")
    var p = Person(
        "Ada",
        36,
        True,
        95.5,
        Address("London", 12345),
    )
    pprint(p)
    print()

    # With type annotations
    print("=== With types ===")
    pprint(p, PrettyPrinter(show_types=True))
    print()

    # Custom indent
    print("=== Custom indent (4 spaces) ===")
    pprint(p, PrettyPrinter(indent=4))
    print()

    # Scalars (use pformat for inline)
    print("=== Scalars ===")
    print("Int:", pformat(42))
    print("Bool:", pformat(True))
    print("Float:", pformat(3.14))
    print("String:", pformat("hello world"))
