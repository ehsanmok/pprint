"""Pretty printer for Mojo structs using reflection.

Uses the moclap workaround: StringLiteral.format() accepts Formattable args
while print() requires Writable. This allows formatting reflected field values.

Known scalar types are detected by comparing type names to avoid recursing
into MLIR primitive types.
"""

from reflection import (
    struct_field_count,
    struct_field_names,
    struct_field_types,
    get_type_name,
    is_struct_type,
)


struct PrettyPrinter(Copyable, Movable, ImplicitlyCopyable):
    """Configuration for pretty printing (like Python's pprint.PrettyPrinter)."""

    var indent: Int
    var max_depth: Int
    var max_items: Int
    var show_types: Bool
    var compact: Bool

    fn __init__(
        out self,
        indent: Int = 2,
        max_depth: Int = 6,
        max_items: Int = 64,
        show_types: Bool = False,
        compact: Bool = False,
    ):
        self.indent = indent
        self.max_depth = max_depth
        self.max_items = max_items
        self.show_types = show_types
        self.compact = compact

    fn __copyinit__(out self, existing: Self):
        self.indent = existing.indent
        self.max_depth = existing.max_depth
        self.max_items = existing.max_items
        self.show_types = existing.show_types
        self.compact = existing.compact

    fn __moveinit__(out self, deinit existing: Self):
        self.indent = existing.indent
        self.max_depth = existing.max_depth
        self.max_items = existing.max_items
        self.show_types = existing.show_types
        self.compact = existing.compact


# Known scalar type names (to avoid recursing into MLIR primitives)
comptime _INT_NAME = get_type_name[Int]()
comptime _BOOL_NAME = get_type_name[Bool]()
comptime _STRING_NAME = get_type_name[String]()
comptime _FLOAT64_NAME = get_type_name[Float64]()
comptime _FLOAT32_NAME = get_type_name[Float32]()
comptime _FLOAT16_NAME = get_type_name[Float16]()


fn pprint[T: AnyType](value: T, pp: PrettyPrinter = PrettyPrinter()):
    """Pretty-print any value to stdout."""
    print(pformat(value, pp))


fn pformat[T: AnyType](value: T, pp: PrettyPrinter = PrettyPrinter()) -> String:
    """Format any value as a pretty string."""
    comptime tname = get_type_name[T]()

    # Check known scalar types at compile time
    @parameter
    if tname == _STRING_NAME:
        var out = '"' + rebind[String](value) + '"'
        if pp.show_types:
            out += " <" + String(tname) + ">"
        return out
    elif tname == _INT_NAME:
        var out = String(rebind[Int](value))
        if pp.show_types:
            out += " <" + String(tname) + ">"
        return out
    elif tname == _BOOL_NAME:
        # Format bool as lowercase true/false (JSON-style)
        var out = String("true") if rebind[Bool](value) else String("false")
        if pp.show_types:
            out += " <" + String(tname) + ">"
        return out
    elif tname == _FLOAT64_NAME or "SIMD[DType.float64" in tname:
        var out = String(rebind[Float64](value))
        if pp.show_types:
            out += " <" + String(tname) + ">"
        return out
    elif tname == _FLOAT32_NAME or "SIMD[DType.float32" in tname:
        var out = String(rebind[Float32](value))
        if pp.show_types:
            out += " <" + String(tname) + ">"
        return out
    elif tname == _FLOAT16_NAME or "SIMD[DType.float16" in tname:
        var out = String(rebind[Float16](value))
        if pp.show_types:
            out += " <" + String(tname) + ">"
        return out
    elif is_struct_type[T]():
        return _format_struct[T](value, pp, 0)
    else:
        # Unknown type - cannot format without Writable trait
        var out = String("<unknown>")
        if pp.show_types:
            out += " <" + String(tname) + ">"
        return out


fn _format_struct[T: AnyType](
    value: T, pp: PrettyPrinter, depth: Int
) -> String:
    """Format a struct using reflection."""
    if depth >= pp.max_depth:
        return "..."

    comptime field_count = struct_field_count[T]()
    comptime field_names = struct_field_names[T]()
    comptime field_types = struct_field_types[T]()

    if field_count == 0:
        return "{}"

    var out = "{"
    var shown = 0

    @parameter
    for idx in range(field_count):
        if shown >= pp.max_items:
            break
        if shown == 0:
            out += "\n"
        else:
            out += ",\n"

        out += _indent(pp.indent, depth + 1)

        comptime field_name = field_names[idx]
        comptime field_type = field_types[idx]
        comptime field_type_name = get_type_name[field_type]()
        out += String(field_name) + ": "

        # Get field reference
        ref field = __struct_field_ref(idx, value)

        # Format based on known scalar types (compile-time checks)
        @parameter
        if field_type_name == _STRING_NAME:
            out += '"' + rebind[String](field) + '"'
        elif field_type_name == _INT_NAME:
            out += String(rebind[Int](field))
        elif field_type_name == _BOOL_NAME:
            # Format bool as lowercase true/false (JSON-style)
            out += "true" if rebind[Bool](field) else "false"
        elif field_type_name == _FLOAT64_NAME or "SIMD[DType.float64" in field_type_name:
            out += String(rebind[Float64](field))
        elif field_type_name == _FLOAT32_NAME or "SIMD[DType.float32" in field_type_name:
            out += String(rebind[Float32](field))
        elif field_type_name == _FLOAT16_NAME or "SIMD[DType.float16" in field_type_name:
            out += String(rebind[Float16](field))
        elif is_struct_type[field_type]():
            # Nested struct: recurse
            out += _format_struct[field_type](
                rebind[field_type](field), pp, depth + 1
            )
        else:
            # Unknown type - cannot format without Writable trait
            out += "<unknown>"

        # Add type annotation if requested
        if pp.show_types:
            var type_str = _format_type_name(field_type_name)
            out += " <" + type_str + ">"

        shown += 1

    if shown < field_count:
        out += ",\n" + _indent(pp.indent, depth + 1) + "..."

    out += "\n" + _indent(pp.indent, depth) + "}"
    return out


fn _format_type_name(name: StaticString) -> String:
    """Format a type name for display, handling SIMD and module prefixes."""
    var type_str = String(name)

    # Handle SIMD types: SIMD[DType.float64, 1] -> Float64
    if "SIMD[DType.float64" in type_str:
        return "Float64"
    if "SIMD[DType.float32" in type_str:
        return "Float32"
    if "SIMD[DType.float16" in type_str:
        return "Float16"

    # Strip module prefix if present (e.g., "module.StructName" -> "StructName")
    var dot_idx = type_str.rfind(".")
    if dot_idx >= 0:
        return String(type_str[dot_idx + 1:])

    return type_str


fn _indent(spaces: Int, depth: Int) -> String:
    """Create indentation string."""
    if spaces <= 0:
        return ""
    return " " * (spaces * depth)
