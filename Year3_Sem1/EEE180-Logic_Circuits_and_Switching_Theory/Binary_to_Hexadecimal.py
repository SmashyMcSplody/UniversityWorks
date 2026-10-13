"""
Binary to Hexadecimal Converter — shows every step of the process.
Handles negative numbers and fractional binary numbers (e.g. 101.101),
loops until you press ESC, and copies the result to the clipboard using
only the standard library (no pip install needed).

WHY grouping by 4 bits works:
Hexadecimal is a base-16 place-value system, and 16 = 2^4 — that's
not a coincidence. Every possible arrangement of 4 bits (0000 through
1111) maps to exactly one hex digit (0 through F), with no gaps and
no overlaps. So instead of doing arithmetic, you just chop the
binary number into groups of 4 bits and translate each group
straight to its matching hex digit, using this table:

  0000 -> 0   0100 -> 4   1000 -> 8   1100 -> C
  0001 -> 1   0101 -> 5   1001 -> 9   1101 -> D
  0010 -> 2   0110 -> 6   1010 -> A   1110 -> E
  0011 -> 3   0111 -> 7   1011 -> B   1111 -> F

(Digits above 9 use letters A-F because hex needs 16 distinct
symbols, and decimal digits only provide 10.)

WHY the integer and fractional parts are grouped from DIFFERENT
directions:
Place values count outward from the binary point in both directions:
1s, 2s, 4s, 8s... to the LEFT, and 1/2s, 1/4s, 1/8s, 1/16s... to the
RIGHT. Groups of 4 bits have to line up with where the point
actually is, so the integer part is grouped starting AT the point
and moving left (padding extra zeros on the far left if needed),
while the fractional part is grouped starting AT the point and
moving right (padding extra zeros on the far right if needed).
Grouping from the wrong end would misalign every digit after the
first group.

WHY the exit key check works:
The ESC key sends a single control byte, \x1b (27 in decimal). We
read raw keyboard input (instead of a normal input() line, which
only reports a key after Enter) so that one byte can be caught the
instant it's pressed.
"""

import sys

ESC_KEY = b"\x1b"

BIT_GROUP_TO_HEX = {
    "0000": "0", "0001": "1", "0010": "2", "0011": "3",
    "0100": "4", "0101": "5", "0110": "6", "0111": "7",
    "1000": "8", "1001": "9", "1010": "A", "1011": "B",
    "1100": "C", "1101": "D", "1110": "E", "1111": "F",
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


def convert_integer_part(bits):
    """Convert a binary integer string (no sign) to hex, printing each step."""
    if bits == "" or bits == "0":
        print("  Integer part is 0 -> hex: 0")
        return "0"

    pad = (4 - len(bits) % 4) % 4
    padded = "0" * pad + bits
    if pad:
        print(f"  Padded with {pad} leading zero(s) so the length divides evenly by 4: {padded}")
    else:
        print(f"  Length is already a multiple of 4: {padded}")

    groups = [padded[i:i + 4] for i in range(0, len(padded), 4)]
    print(f"  Grouped into 4s outward from the point (leftward): {' '.join(groups)}")

    digits = []
    for i, group in enumerate(groups, start=1):
        digit = BIT_GROUP_TO_HEX[group]
        digits.append(digit)
        print(f"    Group {i}: {group} -> {digit}")

    return "".join(digits)


def convert_fractional_part(bits):
    """Convert a binary fractional string (no leading '.') to hex."""
    if bits == "":
        return ""

    pad = (4 - len(bits) % 4) % 4
    padded = bits + "0" * pad
    if pad:
        print(f"  Padded with {pad} trailing zero(s) so the length divides evenly by 4: {padded}")
    else:
        print(f"  Length is already a multiple of 4: {padded}")

    groups = [padded[i:i + 4] for i in range(0, len(padded), 4)]
    print(f"  Grouped into 4s outward from the point (rightward): {' '.join(groups)}")

    digits = []
    for i, group in enumerate(groups, start=1):
        digit = BIT_GROUP_TO_HEX[group]
        digits.append(digit)
        print(f"    Group {i}: {group} -> {digit}")

    return "".join(digits)


def parse_binary(raw):
    """
    Validate and split a binary string like '-101.011' into
    (is_negative, integer_bits, fractional_bits). Raises ValueError
    if the string contains anything other than 0, 1, one optional
    leading '-', and one optional '.'.
    """
    raw = raw.strip()
    is_negative = raw.startswith("-")
    if is_negative:
        raw = raw[1:]

    if "." in raw:
        integer_bits, fractional_bits = raw.split(".", 1)
    else:
        integer_bits, fractional_bits = raw, ""

    integer_bits = integer_bits or "0"

    for ch in integer_bits + fractional_bits:
        if ch not in "01":
            raise ValueError(f"'{ch}' is not a valid binary digit (only 0 and 1 are allowed)")

    return is_negative, integer_bits, fractional_bits


def binary_to_hexadecimal(raw):
    is_negative, integer_bits, fractional_bits = parse_binary(raw)

    display = f"{'-' if is_negative else ''}{integer_bits}" + (f".{fractional_bits}" if fractional_bits else "")
    print(f"Converting binary {display} to hexadecimal:\n")

    print("Integer part:")
    hex_integer = convert_integer_part(integer_bits)

    hex_fraction = ""
    if fractional_bits:
        print("\nFractional part:")
        hex_fraction = convert_fractional_part(fractional_bits)

    result = ("-" if is_negative else "") + hex_integer
    if hex_fraction:
        result += "." + hex_fraction

    print(f"\nFinal hexadecimal result: {result}")
    return result


if __name__ == "__main__":
    print("Binary to Hexadecimal Converter (handles negatives and fractions)")
    print("Press ESC after a conversion to quit, or any other key to go again.\n")

    while True:
        raw = input("Enter a binary number to convert (e.g. -1011.101): ")
        try:
            result = binary_to_hexadecimal(raw)
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