"""Tests for PrettyPrinter configuration options."""
from testing import assert_equal, assert_true, assert_false, TestSuite

from pprint import PrettyPrinter, pformat
from tests.fixtures import (
    SingleField,
    TwoFields,
    Address,
    Level1,
    Level2,
    Level3,
    ManyFields,
    DeepNest1,
    DeepNest2,
    DeepNest3,
    DeepNest4,
)


# =============================================================================
# Default values tests
# =============================================================================

def test_default_indent():
    """Default indent is 2."""
    var pp = PrettyPrinter()
    assert_equal(pp.indent, 2)


def test_default_max_depth():
    """Default max_depth is 6."""
    var pp = PrettyPrinter()
    assert_equal(pp.max_depth, 6)


def test_default_max_items():
    """Default max_items is 64."""
    var pp = PrettyPrinter()
    assert_equal(pp.max_items, 64)


def test_default_show_types():
    """Default show_types is False."""
    var pp = PrettyPrinter()
    assert_false(pp.show_types)


def test_default_compact():
    """Default compact is False."""
    var pp = PrettyPrinter()
    assert_false(pp.compact)


# =============================================================================
# Custom indent tests
# =============================================================================

def test_indent_0():
    """Zero indent - no indentation."""
    var pp = PrettyPrinter(indent=0)
    var s = SingleField(1)
    var out = pformat(s, pp)
    assert_true("value: 1" in out)
    assert_false("  value" in out)


def test_indent_1():
    """Single space indent."""
    var pp = PrettyPrinter(indent=1)
    var s = SingleField(1)
    var out = pformat(s, pp)
    assert_true(" value: 1" in out)
    assert_false("  value" in out)


def test_indent_2():
    """Default 2-space indent."""
    var pp = PrettyPrinter(indent=2)
    var s = SingleField(1)
    var out = pformat(s, pp)
    assert_true("  value: 1" in out)


def test_indent_4():
    """4-space indent."""
    var pp = PrettyPrinter(indent=4)
    var s = SingleField(1)
    var out = pformat(s, pp)
    assert_true("    value: 1" in out)


def test_indent_8():
    """8-space indent."""
    var pp = PrettyPrinter(indent=8)
    var s = SingleField(1)
    var out = pformat(s, pp)
    assert_true("        value: 1" in out)


def test_indent_nested_2():
    """2-space indent affects nested levels."""
    var pp = PrettyPrinter(indent=2)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("  inner:" in out)   # 2 spaces
    assert_true("    inner:" in out)  # 4 spaces
    assert_true("      value:" in out)  # 6 spaces


def test_indent_nested_4():
    """4-space indent affects nested levels."""
    var pp = PrettyPrinter(indent=4)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("    inner:" in out)      # 4 spaces
    assert_true("        inner:" in out)  # 8 spaces
    assert_true("            value:" in out)  # 12 spaces


# =============================================================================
# max_depth tests
# =============================================================================

def test_max_depth_0():
    """Depth 0 immediately returns ellipsis."""
    var pp = PrettyPrinter(max_depth=0)
    var s = SingleField(1)
    assert_equal(pformat(s, pp), "...")


def test_max_depth_1():
    """Depth 1 shows struct but nested as ellipsis."""
    var pp = PrettyPrinter(max_depth=1)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("inner: ..." in out)


def test_max_depth_2():
    """Depth 2 shows two levels."""
    var pp = PrettyPrinter(max_depth=2)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    # Level1 visible
    assert_true("{" in out)
    # Level2 nested shows inner as ellipsis
    assert_true("inner:" in out)


def test_max_depth_3():
    """Depth 3 shows all three levels."""
    var pp = PrettyPrinter(max_depth=3)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("value: 1" in out)


def test_max_depth_scalar_unaffected():
    """Scalars not affected by depth limit."""
    var pp = PrettyPrinter(max_depth=1)
    var s = SingleField(42)
    var out = pformat(s, pp)
    assert_true("value: 42" in out)


def test_max_depth_deep_nesting():
    """4 levels deep with depth limit 2."""
    var pp = PrettyPrinter(max_depth=2)
    var d = DeepNest1(DeepNest2(DeepNest3(DeepNest4(99))))
    var out = pformat(d, pp)
    # First level visible
    assert_true("inner:" in out)
    # Deep value not visible
    assert_false("99" in out)
    # Ellipsis present
    assert_true("..." in out)


def test_max_depth_high_value():
    """High depth limit shows everything."""
    var pp = PrettyPrinter(max_depth=100)
    var d = DeepNest1(DeepNest2(DeepNest3(DeepNest4(99))))
    var out = pformat(d, pp)
    assert_true("value: 99" in out)


# =============================================================================
# max_items tests
# =============================================================================

def test_max_items_1():
    """Item limit 1 shows only first field."""
    var pp = PrettyPrinter(max_items=1)
    var a = Address("NYC", 10001)
    var out = pformat(a, pp)
    assert_true("city:" in out)
    assert_true("..." in out)
    assert_false("zip:" in out)


def test_max_items_2():
    """Item limit 2 on 2-field struct shows all."""
    var pp = PrettyPrinter(max_items=2)
    var a = Address("NYC", 10001)
    var out = pformat(a, pp)
    assert_true("city:" in out)
    assert_true("zip:" in out)
    assert_false("..." in out)


def test_max_items_3_of_8():
    """Item limit 3 on 8-field struct."""
    var pp = PrettyPrinter(max_items=3)
    var m = ManyFields(1, 2, 3, 4, 5, 6, 7, 8)
    var out = pformat(m, pp)
    assert_true("a: 1" in out)
    assert_true("b: 2" in out)
    assert_true("c: 3" in out)
    assert_true("..." in out)
    assert_false("d: 4" in out)
    assert_false("h: 8" in out)


def test_max_items_5_of_8():
    """Item limit 5 on 8-field struct."""
    var pp = PrettyPrinter(max_items=5)
    var m = ManyFields(1, 2, 3, 4, 5, 6, 7, 8)
    var out = pformat(m, pp)
    assert_true("a: 1" in out)
    assert_true("e: 5" in out)
    assert_true("..." in out)
    assert_false("f: 6" in out)


def test_max_items_exact():
    """Item limit equal to field count."""
    var pp = PrettyPrinter(max_items=8)
    var m = ManyFields(1, 2, 3, 4, 5, 6, 7, 8)
    var out = pformat(m, pp)
    assert_true("a: 1" in out)
    assert_true("h: 8" in out)
    assert_false("..." in out)


def test_max_items_greater_than_fields():
    """Item limit greater than field count."""
    var pp = PrettyPrinter(max_items=100)
    var m = ManyFields(1, 2, 3, 4, 5, 6, 7, 8)
    var out = pformat(m, pp)
    assert_true("a: 1" in out)
    assert_true("h: 8" in out)
    assert_false("..." in out)


def test_max_items_0():
    """Item limit 0 shows no fields."""
    var pp = PrettyPrinter(max_items=0)
    var a = Address("NYC", 10001)
    var out = pformat(a, pp)
    assert_false("city:" in out)
    assert_false("zip:" in out)


# =============================================================================
# show_types tests
# =============================================================================

def test_show_types_false():
    """Verify show_types=False hides types."""
    var pp = PrettyPrinter(show_types=False)
    var s = SingleField(42)
    var out = pformat(s, pp)
    assert_false("<Int>" in out)


def test_show_types_true():
    """Verify show_types=True shows types."""
    var pp = PrettyPrinter(show_types=True)
    var s = SingleField(42)
    var out = pformat(s, pp)
    assert_true("<Int>" in out)


def test_show_types_multiple_fields():
    """Verify show_types on multiple fields."""
    var pp = PrettyPrinter(show_types=True)
    var a = Address("NYC", 10001)
    var out = pformat(a, pp)
    assert_true("<String>" in out)
    assert_true("<Int>" in out)


def test_show_types_nested():
    """Verify show_types on nested structs."""
    var pp = PrettyPrinter(show_types=True)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("<Level2>" in out)
    assert_true("<Level3>" in out)
    assert_true("<Int>" in out)


# =============================================================================
# Combined options tests
# =============================================================================

def test_combined_indent_and_depth():
    """Custom indent with depth limit."""
    var pp = PrettyPrinter(indent=4, max_depth=1)
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("    inner: ..." in out)


def test_combined_items_and_types():
    """Item limit with show_types."""
    var pp = PrettyPrinter(max_items=1, show_types=True)
    var a = Address("NYC", 10001)
    var out = pformat(a, pp)
    assert_true("city:" in out)
    assert_true("<String>" in out)
    assert_true("..." in out)
    assert_false("zip:" in out)


def test_combined_all_options():
    """All options combined."""
    var pp = PrettyPrinter(
        indent=4,
        max_depth=2,
        max_items=2,
        show_types=True,
    )
    var n = Level1(Level2(Level3(1)))
    var out = pformat(n, pp)
    assert_true("    inner:" in out)  # 4-space indent
    assert_true("<Level2>" in out)     # show_types


# =============================================================================
# Copy/move semantics tests
# =============================================================================

def test_config_copyable():
    """PrettyPrinter is copyable."""
    var pp1 = PrettyPrinter(indent=4)
    var pp2 = pp1
    assert_equal(pp2.indent, 4)


def test_config_modify_copy():
    """Modifying copy doesn't affect original."""
    var pp1 = PrettyPrinter(indent=4)
    var pp2 = pp1
    pp2.indent = 8
    assert_equal(pp1.indent, 4)
    assert_equal(pp2.indent, 8)


# =============================================================================
# Main
# =============================================================================

def main():
    print("=" * 60)
    print("test_config.mojo")
    print("=" * 60)
    print()
    TestSuite.discover_tests[__functions_in_module()]().run()
