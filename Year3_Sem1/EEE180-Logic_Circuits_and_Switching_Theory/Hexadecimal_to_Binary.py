"""
Hexadecimal to Binary Converter — shows every step of the process.
Handles negative numbers and fractional hex numbers (e.g. 1A.8),
loops until you press ESC, and copies the result to the clipboard using
only the standard library (no pip install needed).

WHY converting digit-by-digit works:
Hexadecimal is a base-16 place-value system, and 16 = 2^4 — that's
not a coincidence. Every hex digit (0 through F) stands for exactly
one arrangement of 4 bits (0000 through 1111), with no gaps and no
overlaps. So instead of doing arithmetic, you just replace each hex
digit with its own 4-bit group, using this table:

  0 -> 0000   4 -> 0100   8 -> 1000   C -> 1100
  1 -> 0001   5 -> 0101   9 -> 1001   D -> 1101
  2 -> 0010   6 -> 0110   A -> 1010   E -> 1110
  3 -> 0011   7 -> 0111   B -> 1011   F -> 1111

(This is just the binary-to-hex table from the other converter,
read in the opposite direction.)

WHY the integer and fractional parts need no special alignment here:
When going binary -> hex, you have to decide where the 4-bit groups
start, which is why that direction pads zeros on different ends.
Going hex -> binary has no such problem: every hex digit already
sits in its own place value, so each one simply expands into 4 bits
in the same position. The binary point stays exactly where it was.

WHY leading/trailing zeros get trimmed at the end:
Expanding every digit gives 4 bits each, so a hex digit like 1
becomes 0001 and the number starts with extra zeros. Leading zeros
on the integer part and trailing zeros on the fractional part don't
change the value (just like 007 = 7 and 0.50 = 0.5), so the final
answer is shown without them. The full, untrimmed expansion is
still printed in the steps so you can see where it came from.

WHY the exit key check works:
The ESC key sends a single control byte, \x1b (27 in decimal). We
read raw keyboard input (instead of a normal input() line, which
only reports a key after Enter) so that one byte can be caught the
instant it's pressed.
"""

import sys

ESC_KEY = b"\x1b"

HEX_TO_BIT_GROUP = {
    "0": "0000", "1": "0001", "2": "0010", "3": "0011",
    "4": "0100", "5": "0101", "6": "0110", "7": "0111",
    "8": "1000", "9": "1001", "A": "1010", "B": "1011",
    "C": "1100", "D": "1101", "E": "1110", "F": "1111",
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


def expand_digits(digits):
    """Expand each hex digit into its 4-bit group, printing every step."""
    groups = []
    for i, digit in enumerate(digits, start=1):
        group = HEX_TO_BIT_GROUP[digit]
        groups.append(group)
        print(f"    Digit {i}: {digit} -> {group}")
    return groups


def convert_integer_part(digits):
    """Convert a hex integer string (no sign) to binary, printing each step."""
    if digits == "" or digits == "0":
        print("  Integer part is 0 -> binary: 0")
        return "0"

    print(f"  Expanding each hex digit into 4 bits (left to right): {digits}")
    groups = expand_digits(digits)

    full = "".join(groups)
    print(f"  Joined together: {' '.join(groups)}")

    trimmed = full.lstrip("0") or "0"
    removed = len(full) - len(trimmed)
    if removed:
        print(f"  Removed {removed} leading zero(s) (they don't change the value): {trimmed}")
    else:
        print("  No leading zeros to remove.")

    return trimmed


def convert_fractional_part(digits):
    """Convert a hex fractional string (no leading '.') to binary."""
    if digits == "":
        return ""

    print(f"  Expanding each hex digit into 4 bits (left to right): {digits}")
    groups = expand_digits(digits)

    full = "".join(groups)
    print(f"  Joined together: {' '.join(groups)}")

    trimmed = full.rstrip("0")
    removed = len(full) - len(trimmed)
    if removed:
        print(f"  Removed {removed} trailing zero(s) (they don't change the value): {trimmed or '(none left)'}")
    else:
        print("  No trailing zeros to remove.")

    return trimmed


def parse_hexadecimal(raw):
    """
    Validate and split a hex string like '-1A.8' into
    (is_negative, integer_digits, fractional_digits). Accepts upper or
    lowercase letters and an optional '0x' prefix. Raises ValueError
    if the string contains anything other than hex digits, one optional
    leading '-', and one optional '.'.
    """
    raw = raw.strip()
    is_negative = raw.startswith("-")
    if is_negative:
        raw = raw[1:]

    if raw.lower().startswith("0x"):
        raw = raw[2:]

    raw = raw.upper()

    if "." in raw:
        integer_digits, fractional_digits = raw.split(".", 1)
    else:
        integer_digits, fractional_digits = raw, ""

    integer_digits = integer_digits or "0"

    for ch in integer_digits + fractional_digits:
        if ch not in HEX_TO_BIT_GROUP:
            raise ValueError(f"'{ch}' is not a valid hexadecimal digit (use 0-9 and A-F)")

    return is_negative, integer_digits, fractional_digits


def hexadecimal_to_binary(raw):
    is_negative, integer_digits, fractional_digits = parse_hexadecimal(raw)

    display = f"{'-' if is_negative else ''}{integer_digits}" + (f".{fractional_digits}" if fractional_digits else "")
    print(f"Converting hexadecimal {display} to binary:\n")

    print("Integer part:")
    bin_integer = convert_integer_part(integer_digits)

    bin_fraction = ""
    if fractional_digits:
        print("\nFractional part:")
        bin_fraction = convert_fractional_part(fractional_digits)

    result = ("-" if is_negative else "") + bin_integer
    if bin_fraction:
        result += "." + bin_fraction

    print(f"\nFinal binary result: {result}")
    return result


if __name__ == "__main__":
    print("Hexadecimal to Binary Converter (handles negatives and fractions)")
    print("Press ESC after a conversion to quit, or any other key to go again.\n")

    while True:
        raw = input("Enter a hexadecimal number to convert (e.g. -1A.8): ")
        try:
            result = hexadecimal_to_binary(raw)
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