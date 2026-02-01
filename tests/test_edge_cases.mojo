"""Tests for edge cases and special scenarios."""
from testing import assert_equal, assert_true, assert_false, TestSuite

from pprint import PrettyPrinter, pprint, pformat
from tests.fixtures import (
    Empty,
    SingleField,
    Address,
    Level1,
    Level2,
    Level3,
)


# =============================================================================
# Special string content
# =============================================================================

def test_string_with_quotes():
    """String containing quotes."""
    var out = pformat("say \"hello\"")
    assert_true("say" in out)


def test_string_with_backslash():
    """String containing backslash."""
    var out = pformat("path\\to\\file")
    assert_true("path" in out)


def test_string_long():
    """Long string."""
    var long_str = "a" * 1000
    var out = pformat(long_str)
    assert_true("aaa" in out)


def test_string_only_spaces():
    """String with only spaces."""
    assert_equal(pformat("   "), '"   "')


# =============================================================================
# Numeric edge cases
# =============================================================================

def test_int_boundary_positive():
    """Large positive integer."""
    var out = pformat(2147483647)
    assert_true("2147483647" in out)


def test_int_boundary_negative():
    """Large negative integer."""
    var out = pformat(-2147483648)
    assert_true("-2147483648" in out)


def test_float_very_small():
    """Very small float."""
    var out = pformat(0.0000001)
    # May be in scientific notation
    assert_true("1" in out or "e" in out)


def test_float_very_large():
    """Very large float."""
    var out = pformat(1e100)
    assert_true("1" in out)


# =============================================================================
# Empty and minimal structs
# =============================================================================

def test_empty_struct_multiple():
    """Multiple empty struct instances."""
    var e1 = Empty()
    var e2 = Empty()
    assert_equal(pformat(e1), pformat(e2))


def test_single_field_various_values():
    """Single field with various values."""
    assert_true("0" in pformat(SingleField(0)))
    assert_true("-1" in pformat(SingleField(-1)))
    assert_true("100" in pformat(SingleField(100)))


# =============================================================================
# Deeply nested structs
# =============================================================================

def test_deep_nesting_default_depth():
    """3-level nesting within default depth limit."""
    var n = Level1(Level2(Level3(42)))
    var out = pformat(n)
    assert_true("value: 42" in out)


def test_deep_nesting_exact_depth():
    """Nesting exactly at depth limit."""
    var pp = PrettyPrinter(max_depth=3)
    var n = Level1(Level2(Level3(42)))
    var out = pformat(n, pp)
    assert_true("value: 42" in out)


def test_deep_nesting_one_below_depth():
    """Nesting one level below depth limit."""
    var pp = PrettyPrinter(max_depth=2)
    var n = Level1(Level2(Level3(42)))
    var out = pformat(n, pp)
    assert_false("value: 42" in out)
    assert_true("..." in out)


# =============================================================================
# Output format verification
# =============================================================================

def test_output_starts_with_brace():
    """Struct output starts with {."""
    var s = SingleField(1)
    var out = pformat(s)
    assert_true(out.startswith("{"))


def test_output_ends_with_brace():
    """Struct output ends with }."""
    var s = SingleField(1)
    var out = pformat(s)
    assert_true(out.endswith("}"))


def test_output_has_newlines():
    """Struct output contains newlines."""
    var s = SingleField(1)
    var out = pformat(s)
    assert_true("\n" in out)


def test_output_field_colon():
    """Fields have colon after name."""
    var s = SingleField(1)
    var out = pformat(s)
    assert_true("value:" in out)


def test_output_comma_between_fields():
    """Multiple fields separated by comma."""
    var a = Address("NYC", 10001)
    var out = pformat(a)
    assert_true(",\n" in out)


# =============================================================================
# Consistency tests
# =============================================================================

def test_same_input_same_output():
    """Same input produces same output."""
    var a1 = Address("NYC", 10001)
    var a2 = Address("NYC", 10001)
    assert_equal(pformat(a1), pformat(a2))


def test_different_config_different_output():
    """Different config produces different output."""
    var s = SingleField(1)
    var out1 = pformat(s, PrettyPrinter(indent=2))
    var out2 = pformat(s, PrettyPrinter(indent=4))
    assert_true(out1 != out2)


def test_scalar_no_braces():
    """Scalar output has no braces."""
    var out = pformat(42)
    assert_false("{" in out)
    assert_false("}" in out)


# =============================================================================
# Type annotation format
# =============================================================================

def test_type_annotation_format():
    """Type annotation uses angle brackets."""
    var pp = PrettyPrinter(show_types=True)
    var out = pformat(42, pp)
    assert_true("<" in out)
    assert_true(">" in out)


def test_type_annotation_after_value():
    """Type annotation comes after value."""
    var pp = PrettyPrinter(show_types=True)
    var out = pformat(42, pp)
    var value_pos = out.find("42")
    var type_pos = out.find("<Int>")
    assert_true(value_pos < type_pos)


# =============================================================================
# pprint function tests
# =============================================================================

def test_pprint_returns_none():
    """pprint function returns None (just prints)."""
    # This test verifies pprint works without error
    # We can't easily capture stdout, so just verify no crash
    pprint(42)
    pprint(SingleField(1))
    pprint(Address("NYC", 10001))


def test_pprint_with_config():
    """pprint with PrettyPrinter config."""
    var pp = PrettyPrinter(indent=4, show_types=True)
    pprint(SingleField(42), pp)  # Should not crash


# =============================================================================
# Main
# =============================================================================

def main():
    print("=" * 60)
    print("test_edge_cases.mojo")
    print("=" * 60)
    print()
    TestSuite.discover_tests[__functions_in_module()]().run()
