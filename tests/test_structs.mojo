"""Tests for struct formatting."""
from testing import assert_equal, assert_true, assert_false, TestSuite

from pprint import PrettyPrinter, pformat
from tests.fixtures import (
    Empty,
    SingleField,
    TwoFields,
    Address,
    Person,
    Level1,
    Level2,
    Level3,
    AllTypes,
)


# =============================================================================
# Empty struct tests
# =============================================================================

def test_empty_struct():
    """Empty struct prints as {}."""
    assert_equal(pformat(Empty()), "{}")


def test_empty_struct_with_types():
    """Empty struct with show_types still prints {}."""
    var pp = PrettyPrinter(show_types=True)
    assert_equal(pformat(Empty(), pp), "{}")


# =============================================================================
# Single field struct tests
# =============================================================================

def test_single_field():
    """Single field struct."""
    var s = SingleField(42)
    var expected = "{\n  value: 42\n}"
    assert_equal(pformat(s), expected)


def test_single_field_zero():
    """Single field with zero value."""
    var s = SingleField(0)
    var expected = "{\n  value: 0\n}"
    assert_equal(pformat(s), expected)


def test_single_field_negative():
    """Single field with negative value."""
    var s = SingleField(-10)
    var expected = "{\n  value: -10\n}"
    assert_equal(pformat(s), expected)


# =============================================================================
# Two field struct tests
# =============================================================================

def test_two_fields():
    """Two field struct."""
    var s = TwoFields(1, 2)
    var out = pformat(s)
    assert_true("x: 1" in out)
    assert_true("y: 2" in out)
    assert_true(",\n" in out)  # Comma between fields


def test_address():
    """Address struct with string and int."""
    var a = Address("Paris", 75001)
    var expected = "{\n  city: \"Paris\",\n  zip: 75001\n}"
    assert_equal(pformat(a), expected)


def test_address_empty_city():
    """Address with empty city string."""
    var a = Address("", 12345)
    var out = pformat(a)
    assert_true('city: ""' in out)
    assert_true("zip: 12345" in out)


# =============================================================================
# Multi-field struct tests
# =============================================================================

def test_person():
    """Person struct with various field types."""
    var p = Person(
        "Ada",
        36,
        True,
        95.5,
        Address("London", 12345),
    )
    var out = pformat(p)
    assert_true('name: "Ada"' in out)
    assert_true("age: 36" in out)
    assert_true("active: true" in out)
    assert_true("score: 95.5" in out)
    assert_true('city: "London"' in out)
    assert_true("zip: 12345" in out)


def test_person_inactive():
    """Person with false boolean."""
    var p = Person(
        "Bob",
        25,
        False,
        50.0,
        Address("NYC", 10001),
    )
    var out = pformat(p)
    assert_true("active: false" in out)


def test_all_types():
    """Struct with all supported scalar types."""
    var a = AllTypes(42, True, "hello", 3.14)
    var out = pformat(a)
    assert_true("int_val: 42" in out)
    assert_true("bool_val: true" in out)
    assert_true('str_val: "hello"' in out)
    assert_true("float_val: 3.14" in out)


# =============================================================================
# Nested struct tests
# =============================================================================

def test_nested_basic():
    """Basic nested struct."""
    var n = Level1(Level2(Level3(42)))
    var out = pformat(n)
    assert_true("inner:" in out)
    assert_true("value: 42" in out)


def test_nested_indentation():
    """Nested structs have proper indentation."""
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n)
    # Level 1 content at 2 spaces
    assert_true("  inner:" in out)
    # Level 2 content at 4 spaces
    assert_true("    inner:" in out)
    # Level 3 content at 6 spaces
    assert_true("      value: 1" in out)


def test_nested_braces():
    """Nested structs have matching braces."""
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n)
    # Count braces
    var open_count = 0
    var close_count = 0
    for c in out.codepoint_slices():
        if c == "{":
            open_count += 1
        elif c == "}":
            close_count += 1
    assert_equal(open_count, 3)
    assert_equal(close_count, 3)


# =============================================================================
# Struct with show_types
# =============================================================================

def test_show_types_simple():
    """Type hints on simple struct."""
    var pp = PrettyPrinter(show_types=True)
    var a = Address("NYC", 10001)
    var out = pformat(a, pp)
    assert_true("<String>" in out)
    assert_true("<Int>" in out)


def test_show_types_nested():
    """Type hints for nested struct."""
    var pp = PrettyPrinter(show_types=True)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("<Level2>" in out)
    assert_true("<Level3>" in out)
    assert_true("<Int>" in out)


def test_show_types_all_types():
    """Type hints for all scalar types."""
    var pp = PrettyPrinter(show_types=True)
    var a = AllTypes(42, True, "hi", 1.5)
    var out = pformat(a, pp)
    assert_true("<Int>" in out)
    assert_true("<Bool>" in out)
    assert_true("<String>" in out)


# =============================================================================
# Main
# =============================================================================

def main():
    print("=" * 60)
    print("test_structs.mojo")
    print("=" * 60)
    print()
    TestSuite.discover_tests[__functions_in_module()]().run()
