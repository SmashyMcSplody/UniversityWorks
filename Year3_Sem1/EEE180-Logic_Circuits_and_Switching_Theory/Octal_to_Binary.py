"""
Octal to Binary Converter — shows every step of the process.
Handles negative numbers and fractional octal numbers (e.g. -17.4),
loops until you press ESC, and copies the result to the clipboard using
only the standard library (no pip install needed).

WHY this is a straight substitution, not arithmetic:
Octal is base 8, and 8 = 2^3 — every octal digit (0-7) corresponds to
exactly one 3-bit binary pattern, with no gaps and no overlap. That
means there's no math to do at all: you just look up each octal
digit's 3-bit group and glue them together, using this table:

  0 -> 000   2 -> 010   4 -> 100   6 -> 110
  1 -> 001   3 -> 011   5 -> 101   7 -> 111

This is the exact reverse of binary-to-octal, which grouped bits
into 3s and read off octal digits; here we expand each octal digit
back out into its 3 bits.

WHY leading/trailing zeros get trimmed at the end:
Because every digit is forced into a fixed 3-bit group regardless of
its actual size, the raw concatenation can carry extra zeros that
don't affect the value — e.g. octal digit '1' becomes '001', but
'001' and '1' represent the same number. So leading zeros are
stripped from the integer part, and trailing zeros are stripped from
the fractional part, once all the groups are joined together.

WHY the exit key check works:
The ESC key sends a single control byte, \x1b (27 in decimal). We
read raw keyboard input (instead of a normal input() line, which
only reports a key after Enter) so that one byte can be caught the
instant it's pressed.
"""

import sys

ESC_KEY = b"\x1b"

OCTAL_TO_BIT_GROUP = {
    "0": "000", "1": "001", "2": "010", "3": "011",
    "4": "100", "5": "101", "6": "110", "7": "111",
}


def wait_for_keypress():
    """
    Block until a single key is pressed and return it as bytes.
    Uses msvcrt on Windows, and termios/tty on Mac/Linux, since the
    two operating systems handle raw (unbuffered) key reads differently.
    """
    try:
        import msvcrt  # Windows only
        return msvcrt.getch()
    except ImportError:
        import termios
        import tty
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(fd)
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch.encode()


def copy_to_clipboard(text):
    """
    Copy text to the system clipboard using ONLY the standard library —
    no pip install, no external package. Calls the OS's own
    clipboard tool directly (clip on Windows, pbcopy on macOS,
    xclip/xsel on Linux) via subprocess.
    """
    import subprocess

    if sys.platform == "win32":
        commands = [["clip"]]
        encoding = "utf-16-le"  # clip.exe expects UTF-16 on Windows
    elif sys.platform == "darwin":
        commands = [["pbcopy"]]
        encoding = "utf-8"
    else:  # Linux and other Unix-likes
        commands = [["xclip", "-selection", "clipboard"], ["xsel", "--clipboard", "--input"]]
        encoding = "utf-8"

    for command in commands:
        try:
            subprocess.run(command, input=text.encode(encoding), check=True)
            return True
        except (FileNotFoundError, subprocess.CalledProcessError):
            continue  # try the next tool, if any

    return False


def convert_integer_part(digits):
    """Convert an octal integer string (no sign) to binary, printing each step."""
    if digits == "" or digits == "0":
        print("  Integer part is 0 -> binary: 0")
        return "0"

    print("  Each octal digit expands to its own fixed 3-bit group:")
    groups = []
    for i, digit in enumerate(digits, start=1):
        group = OCTAL_TO_BIT_GROUP[digit]
        groups.append(group)
        print(f"    Digit {i}: {digit} -> {group}")

    raw = "".join(groups)
    print(f"  Concatenated groups: {raw}")

    stripped = raw.lstrip("0") or "0"
    if stripped != raw:
        print(f"  Stripped leading zero(s) (they don't change the value): {stripped}")

    return stripped


def convert_fractional_part(digits):
    """Convert an octal fractional string (no leading '.') to binary."""
    if digits == "":
        return ""

    print("  Each octal digit expands to its own fixed 3-bit group:")
    groups = []
    for i, digit in enumerate(digits, start=1):
        group = OCTAL_TO_BIT_GROUP[digit]
        groups.append(group)
        print(f"    Digit {i}: {digit} -> {group}")

    raw = "".join(groups)
    print(f"  Concatenated groups: {raw}")

    stripped = raw.rstrip("0")
    if stripped != raw:
        shown = stripped if stripped else "(nothing left — the fraction was actually 0)"
        print(f"  Stripped trailing zero(s) (they don't change the value): {shown}")

    return stripped


def parse_octal(raw):
    """
    Validate and split an octal string like '-17.4' into
    (is_negative, integer_digits, fractional_digits). Raises
    ValueError if the string contains anything other than digits
    0-7, one optional leading '-', and one optional '.'.
    """
    raw = raw.strip()
    is_negative = raw.startswith("-")
    if is_negative:
        raw = raw[1:]

    if "." in raw:
        integer_digits, fractional_digits = raw.split(".", 1)
    else:
        integer_digits, fractional_digits = raw, ""

    integer_digits = integer_digits or "0"

    for ch in integer_digits + fractional_digits:
        if ch not in "01234567":
            raise ValueError(f"'{ch}' is not a valid octal digit (only 0-7 are allowed)")

    return is_negative, integer_digits, fractional_digits


def octal_to_binary(raw):
    is_negative, integer_digits, fractional_digits = parse_octal(raw)

    display = f"{'-' if is_negative else ''}{integer_digits}" + (f".{fractional_digits}" if fractional_digits else "")
    print(f"Converting octal {display} to binary:\n")

    print("Integer part:")
    binary_integer = convert_integer_part(integer_digits)

    binary_fraction = ""
    if fractional_digits:
        print("\nFractional part:")
        binary_fraction = convert_fractional_part(fractional_digits)

    result = ("-" if is_negative else "") + binary_integer
    if binary_fraction:
        result += "." + binary_fraction

    print(f"\nFinal binary result: {result}")
    return result


if __name__ == "__main__":
    print("Octal to Binary Converter (handles negatives and fractions)")
    print("Press ESC after a conversion to quit, or any other key to go again.\n")

    while True:
        raw = input("Enter an octal number to convert (e.g. -17.4): ")
        try:
            result = octal_to_binary(raw)
        except ValueError as e:
            print(f"Invalid input: {e}\n")
            continue

        if copy_to_clipboard(result):
            print(f"\n✓ Copied '{result}' to clipboard.")
        else:
            print("\n(Couldn't find a clipboard tool on this system — copy skipped.)")

        print("\n[ Press ESC to exit, or any other key to convert another number ]")
        key = wait_for_keypress()
        if key == ESC_KEY:
            print("Exiting.")
            break
        print()  # blank line before the next round