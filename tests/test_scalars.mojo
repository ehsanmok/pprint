"""Tests for scalar type formatting."""
from testing import assert_equal, assert_true, assert_false, TestSuite

from pprint import PrettyPrinter, pformat


# =============================================================================
# Integer tests
# =============================================================================

def test_int_positive():
    """Positive integer."""
    assert_equal(pformat(42), "42")


def test_int_negative():
    """Negative integer."""
    assert_equal(pformat(-123), "-123")


def test_int_zero():
    """Zero."""
    assert_equal(pformat(0), "0")


def test_int_large():
    """Large integer."""
    assert_equal(pformat(999999999), "999999999")


def test_int_small():
    """Small integer."""
    assert_equal(pformat(1), "1")


def test_int_max():
    """Very large integer."""
    assert_equal(pformat(9223372036854775807), "9223372036854775807")


# =============================================================================
# Boolean tests
# =============================================================================

def test_bool_true():
    """Boolean true is lowercase."""
    assert_equal(pformat(True), "true")


def test_bool_false():
    """Boolean false is lowercase."""
    assert_equal(pformat(False), "false")


# =============================================================================
# Float tests
# =============================================================================

def test_float_positive():
    """Positive float."""
    var out = pformat(3.14)
    assert_true("3.14" in out)


def test_float_negative():
    """Negative float."""
    var out = pformat(-2.5)
    assert_true("-2.5" in out)


def test_float_zero():
    """Zero float."""
    var out = pformat(0.0)
    assert_true("0" in out)


def test_float_small():
    """Small float."""
    var out = pformat(0.001)
    assert_true("0.001" in out)


def test_float_large():
    """Large float."""
    var out = pformat(1234567.89)
    assert_true("1234567" in out)


# =============================================================================
# String tests
# =============================================================================

def test_string_simple():
    """Simple string is quoted."""
    assert_equal(pformat("hello"), '"hello"')


def test_string_empty():
    """Empty string is quoted."""
    assert_equal(pformat(""), '""')


def test_string_with_spaces():
    """String with spaces."""
    assert_equal(pformat("hello world"), '"hello world"')


def test_string_single_char():
    """Single character string."""
    assert_equal(pformat("a"), '"a"')


def test_string_numbers():
    """String containing numbers."""
    assert_equal(pformat("123"), '"123"')


def test_string_mixed():
    """String with mixed content."""
    assert_equal(pformat("abc 123 xyz"), '"abc 123 xyz"')


def test_string_unicode():
    """String with unicode characters."""
    var out = pformat("こんにちは")
    assert_true("こんにちは" in out)


def test_string_newline():
    """String with newline."""
    var out = pformat("hello\nworld")
    assert_true("hello" in out)


def test_string_tab():
    """String with tab."""
    var out = pformat("hello\tworld")
    assert_true("hello" in out)


# =============================================================================
# Scalars with show_types
# =============================================================================

def test_int_with_type():
    """Int with type annotation."""
    var pp = PrettyPrinter(show_types=True)
    var out = pformat(42, pp)
    assert_true("42" in out)
    assert_true("<Int>" in out)


def test_bool_with_type():
    """Bool with type annotation."""
    var pp = PrettyPrinter(show_types=True)
    var out = pformat(True, pp)
    assert_true("true" in out)
    assert_true("<Bool>" in out)


def test_string_with_type():
    """String with type annotation."""
    var pp = PrettyPrinter(show_types=True)
    var out = pformat("test", pp)
    assert_true('"test"' in out)
    assert_true("<String>" in out)


def test_float_with_type():
    """Float with type annotation."""
    var pp = PrettyPrinter(show_types=True)
    var out = pformat(3.14, pp)
    assert_true("3.14" in out)
    # Float64 type annotation
    assert_true("<" in out)


# =============================================================================
# Main
# =============================================================================

def main():
    print("=" * 60)
    print("test_scalars.mojo")
    print("=" * 60)
    print()
    TestSuite.discover_tests[__functions_in_module()]().run()
