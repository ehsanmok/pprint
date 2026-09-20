"""Shared test fixtures for pprint tests."""


@fieldwise_init
struct Empty(Copyable):
    """Empty struct for testing."""

    pass


@fieldwise_init
struct SingleField(Copyable):
    """Single field struct."""

    var value: Int


@fieldwise_init
struct TwoFields(Copyable):
    """Two field struct."""

    var x: Int
    var y: Int


@fieldwise_init
struct Address(Copyable):
    """Address with string and int fields."""

    var city: String
    var zip: Int


@fieldwise_init
struct Person(Copyable):
    """Person with multiple field types."""

    var name: String
    var age: Int
    var active: Bool
    var score: Float64
    var address: Address


@fieldwise_init
struct Level3(Copyable):
    """Deepest nested struct."""

    var value: Int


@fieldwise_init
struct Level2(Copyable):
    """Middle nested struct."""

    var inner: Level3


@fieldwise_init
struct Level1(Copyable):
    """Top level nested struct."""

    var inner: Level2


@fieldwise_init
struct ManyFields(Copyable):
    """Struct with 8 fields for item limit testing."""

    var a: Int
    var b: Int
    var c: Int
    var d: Int
    var e: Int
    var f: Int
    var g: Int
    var h: Int


@fieldwise_init
struct AllTypes(Copyable):
    """Struct with all supported scalar types."""

    var int_val: Int
    var bool_val: Bool
    var str_val: String
    var float_val: Float64


@fieldwise_init
struct DeepNest4(Copyable):
    """Level 4 nesting."""

    var value: Int


@fieldwise_init
struct DeepNest3(Copyable):
    """Level 3 nesting."""

    var inner: DeepNest4


@fieldwise_init
struct DeepNest2(Copyable):
    """Level 2 nesting."""

    var inner: DeepNest3


@fieldwise_init
struct DeepNest1(Copyable):
    """Level 1 nesting - 4 levels deep total."""

    var inner: DeepNest2
