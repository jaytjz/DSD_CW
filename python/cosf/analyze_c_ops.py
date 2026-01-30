"""
C Code Arithmetic Operations Analyzer

Analyzes C source files to count arithmetic operations by type (add, sub, mul, etc.)
and category (floating-point vs integer). Useful for profiling hardware resource usage.

Usage:
    python analyze_c_ops.py <file.c> [output.log]
"""

import re
import sys
import os

# =============================================================================
# TYPE DEFINITIONS
# =============================================================================

FLOAT_TYPES = {'float', 'double'}

INT_TYPES = {'int', 'int8_t', 'int16_t', 'int32_t', 'int64_t',
             'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t',
             'char', 'short', 'long', 'size_t', 'unsigned'}

C_KEYWORDS = {'if', 'for', 'while', 'switch', 'return', 'sizeof',
              'float', 'double', 'int', 'char', 'void', 'const',
              'static', 'unsigned', 'signed'}

# =============================================================================
# OPERATOR DEFINITIONS
# =============================================================================

FLOAT_OPS = ['add', 'sub', 'mul', 'div', 'mod', 'neg', 'inc_dec']

INT_OPS = ['add', 'sub', 'mul', 'div', 'mod', 'neg', 'inc_dec',
           'bitwise_and', 'bitwise_or', 'bitwise_xor', 'bitwise_not',
           'shift_left', 'shift_right',
           'cmp_lt', 'cmp_gt', 'cmp_le', 'cmp_ge', 'cmp_eq', 'cmp_ne']

OP_LABELS = {
    'add': 'Addition (+)',
    'sub': 'Subtraction (-)',
    'mul': 'Multiplication (*)',
    'div': 'Division (/)',
    'mod': 'Modulo (%)',
    'neg': 'Negation (-x)',
    'inc_dec': 'Increment/Decrement (++/--)',
    'bitwise_and': 'Bitwise AND (&)',
    'bitwise_or': 'Bitwise OR (|)',
    'bitwise_xor': 'Bitwise XOR (^)',
    'bitwise_not': 'Bitwise NOT (~)',
    'shift_left': 'Shift Left (<<)',
    'shift_right': 'Shift Right (>>)',
    'cmp_lt': 'Less Than (<)',
    'cmp_gt': 'Greater Than (>)',
    'cmp_le': 'Less or Equal (<=)',
    'cmp_ge': 'Greater or Equal (>=)',
    'cmp_eq': 'Equal (==)',
    'cmp_ne': 'Not Equal (!=)',
}

# Maps tokens to operation names
ARITH_OPS    = {'+': 'add', '-': 'sub', '*': 'mul', '/': 'div', '%': 'mod'}
COMPARE_OPS  = {'<': 'cmp_lt', '>': 'cmp_gt', '<=': 'cmp_le',
                '>=': 'cmp_ge', '==': 'cmp_eq', '!=': 'cmp_ne'}
SHIFT_OPS    = {'<<': 'shift_left', '>>': 'shift_right',
                '<<=': 'shift_left', '>>=': 'shift_right'}
BITWISE_OPS  = {'&': 'bitwise_and', '|': 'bitwise_or', '^': 'bitwise_xor',
                '&=': 'bitwise_and', '|=': 'bitwise_or', '^=': 'bitwise_xor'}
COMPOUND_OPS = {'+=', '-=', '*=', '/=', '%='}
UNARY_CONTEXT = {'+', '-', '*', '/', '%', '=', '<', '>', '!', '~', '^', '|', '&',
                 '(', '[', ',', '{', '?', ':', 'return', 'case'}

# =============================================================================
# TOKENIZER
# =============================================================================

TOKEN_REGEX = re.compile(r'''
    (\d+\.?\d*[eE][+-]?\d+[fFlL]?)  |  # Scientific notation: 1.5e-10
    (\d*\.\d+[fFlL]?)               |  # Decimal: .5, 0.5
    (\d+\.\d*[fFlL]?)               |  # Decimal: 1., 1.5
    (\d+[fF])                       |  # Float suffix: 1f
    (0x[0-9a-fA-F]+)                |  # Hex: 0xFF
    (\d+)                           |  # Integer: 123
    ([a-zA-Z_]\w*)                  |  # Identifier: var_name
    (\+\+|--)                       |  # Increment/decrement
    (<<=|>>=|<<|>>)                 |  # Shift operators
    (<=|>=|==|!=)                   |  # Comparison operators
    ([+\-*/%&|^]=)                  |  # Compound assignments
    ([+\-*/%&|^~<>=?:])             |  # Single operators (incl. ternary)
    ([(){}\[\];,])                     # Punctuation
''', re.VERBOSE)


def tokenize(code):
    """Split code into tokens."""
    return [m.group(0) for m in TOKEN_REGEX.finditer(code) if m.group(0).strip()]


def is_float_literal(token):
    """Check if token is a floating-point literal (e.g., 1.5, 1e-10, 1.0f)."""
    if not token or not token[0].isdigit():
        return False
    patterns = [
        r'^\d+\.\d*([eE][+-]?\d+)?[fFlL]?$',  # 1.0, 1.5e-10
        r'^\d*\.\d+([eE][+-]?\d+)?[fFlL]?$',  # .5, .5e10
        r'^\d+[eE][+-]?\d+[fFlL]?$',          # 1e10
        r'^\d+[fF]$'                           # 1f
    ]
    return any(re.match(p, token) for p in patterns)


def is_numeric_literal(token):
    """Check if token is any numeric literal."""
    return token and token[0].isdigit()

# =============================================================================
# CODE PREPROCESSING
# =============================================================================

def remove_comments_and_strings(code):
    """Remove comments, preprocessor directives, and string literals."""
    code = re.sub(r'//.*', '', code)                          # Single-line comments
    code = re.sub(r'/\*.*?\*/', '', code, flags=re.DOTALL)    # Multi-line comments
    code = re.sub(r'^\s*#.*$', '', code, flags=re.MULTILINE)  # Preprocessor
    code = re.sub(r'"[^"]*"', '""', code)                     # Strings
    code = re.sub(r"'[^']*'", "''", code)                     # Chars
    return code


def extract_functions(code):
    """Extract function names, signatures, and bodies from C code."""
    code = remove_comments_and_strings(code)
    code = re.sub(r'typedef\s+\w+\s*\{[^}]*\}\s*\w+\s*;', '', code, flags=re.DOTALL)

    functions = {}
    lines = code.split('\n')
    i = 0

    while i < len(lines):
        line = lines[i].strip()

        # Look for function definition: "type name("
        match = re.match(r'^([\w\s\*]+)\s+(\w+)\s*\(', line)
        if not match or '{' in line[:match.end()]:
            i += 1
            continue

        func_name = match.group(2)

        # Skip control flow keywords and forward declarations
        if func_name in ('if', 'for', 'while', 'switch', 'do') or ';' in line:
            i += 1
            continue

        # Collect signature (everything before '{')
        signature_parts = []
        j = i
        while j < len(lines) and '{' not in lines[j]:
            signature_parts.append(lines[j])
            j += 1
        if j < len(lines):
            signature_parts.append(lines[j].split('{')[0])
        signature = ' '.join(signature_parts)

        # Collect body using brace matching
        if j < len(lines):
            brace_depth = 0
            body_lines = []
            while j < len(lines):
                brace_depth += lines[j].count('{') - lines[j].count('}')
                body_lines.append(lines[j])
                if brace_depth == 0:
                    break
                j += 1

            functions[func_name] = {
                'signature': signature,
                'body': '\n'.join(body_lines)
            }
            i = j + 1
        else:
            i += 1

    return functions

# =============================================================================
# VARIABLE DETECTION
# =============================================================================

def find_typed_variables(code, signature, type_names):
    """Find all variables declared with given types."""
    variables = set()

    # Pattern: [const/static] type var1, var2, ...;
    for type_name in type_names:
        pattern = rf'\b(?:const\s+|static\s+|volatile\s+)*{type_name}\s+([^;{{(]+)[;{{]'
        for match in re.findall(pattern, code):
            for part in match.split(','):
                # Clean up: remove initializers, arrays, pointers
                part = re.sub(r'=.*', '', part)
                part = re.sub(r'\[.*?\]', '', part)
                part = part.replace('*', '').strip()

                if name := re.match(r'^([a-zA-Z_]\w*)', part):
                    if name.group(1) not in C_KEYWORDS:
                        variables.add(name.group(1))

    # Also check function parameters
    if param_match := re.search(r'\(([^)]*)\)', signature):
        for param in param_match.group(1).split(','):
            for type_name in type_names:
                if m := re.search(rf'\b{type_name}\s+\*?\s*([a-zA-Z_]\w*)\s*$', param.strip()):
                    variables.add(m.group(1))
                    break

    return variables

# =============================================================================
# OPERATION COUNTING
# =============================================================================

def create_empty_counts():
    """Create zeroed operation counters."""
    return {
        'float': {op: 0 for op in FLOAT_OPS},
        'int': {op: 0 for op in INT_OPS}
    }


def count_operations(body, signature, global_floats=None, global_ints=None):
    """Count all arithmetic operations in a function body."""

    # Collect all typed variables
    float_vars = find_typed_variables(body, signature, FLOAT_TYPES)
    int_vars = find_typed_variables(body, signature, INT_TYPES)
    if global_floats:
        float_vars.update(global_floats)
    if global_ints:
        int_vars.update(global_ints)

    tokens = tokenize(body)
    counts = create_empty_counts()

    def get_operand(idx, direction):
        """Find the variable or literal next to an operator."""
        j = idx + direction
        skip_chars = {'(', ')', '[', ']', '.', '->', '+', '-', '~', '!', '*', '&'}
        while 0 <= j < len(tokens):
            tok = tokens[j]
            if re.match(r'^[a-zA-Z_]\w*$', tok) or tok[0].isdigit():
                return tok
            if tok not in skip_chars:
                break
            j += direction
        return None

    def involves_float(idx):
        """Check if operation involves floating-point operands."""
        left, right = get_operand(idx, -1), get_operand(idx, 1)
        return (left in float_vars or right in float_vars or
                is_float_literal(left) or is_float_literal(right))

    def is_unary(idx):
        """Check if operator is unary (no left operand)."""
        if idx == 0:
            return True
        return tokens[idx - 1] in UNARY_CONTEXT

    def get_unary_target(idx):
        """Get the operand of a unary operator, skipping parens."""
        j = idx + 1
        while j < len(tokens) and tokens[j] in {'(', '+', '-', '~', '!'}:
            if tokens[j] == '(':
                depth = 1
                j += 1
                while j < len(tokens) and depth > 0:
                    depth += (tokens[j] == '(') - (tokens[j] == ')')
                    j += 1
            else:
                j += 1
        return tokens[j] if j < len(tokens) else None

    def record(typ, op):
        """Record an operation."""
        counts[typ][op] += 1

    # Main counting loop
    i = 0
    while i < len(tokens):
        tok = tokens[i]

        # Increment/decrement (++/--)
        if tok in {'++', '--'}:
            var = get_operand(i, -1) or get_operand(i, 1)
            record('float' if var in float_vars else 'int', 'inc_dec')

        # Shift operators (always int)
        elif tok in SHIFT_OPS:
            record('int', SHIFT_OPS[tok])

        # Bitwise operators (always int)
        elif tok in BITWISE_OPS:
            # Skip && and ||
            if tok in '&|' and i + 1 < len(tokens) and tokens[i + 1] == tok:
                i += 1
            else:
                record('int', BITWISE_OPS[tok])

        elif tok == '~':
            record('int', 'bitwise_not')

        # Comparison operators (always int result)
        elif tok in COMPARE_OPS:
            record('int', COMPARE_OPS[tok])

        # Compound arithmetic (+=, -=, etc.)
        elif tok in COMPOUND_OPS:
            op = ARITH_OPS[tok[0]]
            var = get_operand(i, -1)
            if tok == '%=':
                record('int', 'mod')
            elif var in float_vars:
                record('float', op)
            else:
                record('int', op)

        # Basic arithmetic (+, -, *, /, %)
        elif tok in ARITH_OPS:

            # Handle unary minus
            if tok == '-' and is_unary(i):
                target = get_unary_target(i)

                # Skip negative literals (compile-time, not runtime)
                if is_numeric_literal(target):
                    pass
                elif target in float_vars:
                    record('float', 'neg')
                elif target and target.startswith(('my__kernel_', 'my__ieee754_')):
                    record('float', 'neg')  # Known float-returning functions
                elif target in int_vars:
                    record('int', 'neg')
                else:
                    record('float', 'neg')  # Default to float

            # Handle unary plus (no-op, skip)
            elif tok == '+' and is_unary(i):
                pass

            # Binary arithmetic
            elif tok == '%':
                record('int', 'mod')  # Modulo is always int
            elif involves_float(i):
                record('float', ARITH_OPS[tok])
            else:
                record('int', ARITH_OPS[tok])

        i += 1

    return counts

# =============================================================================
# FILE ANALYSIS
# =============================================================================

def analyze_file(filepath):
    """Analyze a C file and return operation counts per function."""
    with open(filepath) as f:
        code = f.read()

    # Find global variables
    clean = remove_comments_and_strings(code)
    global_floats = find_typed_variables(clean, '', FLOAT_TYPES)
    global_ints = find_typed_variables(clean, '', INT_TYPES)

    # Analyze each function
    results = {}
    for name, data in extract_functions(code).items():
        results[name] = count_operations(
            data['body'], data['signature'],
            global_floats, global_ints
        )

    return results

# =============================================================================
# OUTPUT
# =============================================================================

def write_results(results, logfile):
    """Write analysis results to a log file."""

    def write_ops(f, ops, indent=""):
        """Write non-zero operations."""
        for key, val in ops.items():
            if val > 0:
                f.write(f"{indent}{OP_LABELS[key]:30s} {val:4d}\n")

    with open(logfile, 'w') as f:
        f.write("=" * 70 + "\n")
        f.write("C Code Arithmetic Operations Analysis\n")
        f.write("=" * 70 + "\n")

        if not results:
            f.write("\nNo functions found.\n")
            return

        totals = create_empty_counts()

        # Per-function results
        for func_name, ops in sorted(results.items()):
            f.write(f"\nFunction: {func_name}\n")

            float_total = sum(ops['float'].values())
            f.write(f"\n  Floating-Point Operations: {float_total}\n")
            write_ops(f, ops['float'], "    ")

            int_total = sum(ops['int'].values())
            f.write(f"\n  Integer Operations: {int_total}\n")
            write_ops(f, ops['int'], "    ")

            f.write(f"\n  Total: {float_total + int_total}\n")

            # Accumulate totals
            for key in ops['float']:
                totals['float'][key] += ops['float'][key]
            for key in ops['int']:
                totals['int'][key] += ops['int'][key]

        # Summary
        f.write("\n" + "-" * 70 + "\n")
        f.write("SUMMARY\n")
        f.write("-" * 70 + "\n")
        f.write(f"\nFunctions analyzed: {len(results)}\n")

        float_total = sum(totals['float'].values())
        f.write(f"\nFloating-Point Operations: {float_total}\n")
        write_ops(f, totals['float'], "  ")

        int_total = sum(totals['int'].values())
        f.write(f"\nInteger Operations: {int_total}\n")
        write_ops(f, totals['int'], "  ")

        f.write(f"\nTotal Operations: {float_total + int_total}\n")
        f.write("=" * 70 + "\n")

# =============================================================================
# MAIN
# =============================================================================

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python analyze_c_ops.py <file.c> [output.log]")
        sys.exit(1)

    c_file = sys.argv[1]
    logfile = (sys.argv[2] if len(sys.argv) > 2
               else os.path.splitext(os.path.basename(c_file))[0] + "_ops_analysis.log")

    try:
        results = analyze_file(c_file)
        write_results(results, logfile)
        print(f"Analysis written to: {logfile}")
    except FileNotFoundError:
        print(f"Error: File '{c_file}' not found")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
