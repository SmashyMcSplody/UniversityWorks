"""
Binary to Octal Converter — shows every step of the process.
Handles negative numbers and fractional binary numbers (e.g. 101.101),
loops until you press ESC, and copies the result to the clipboard using
only the standard library (no pip install needed).

WHY grouping by 3 bits works:
Octal is a base-8 place-value system, and 8 = 2^3. That's not a
coincidence — every possible arrangement of 3 bits (000 through 111)
maps to exactly one octal digit (0 through 7), with no gaps and no
overlaps. So instead of doing arithmetic bit by bit, you can just
chop the binary number into groups of 3 bits and translate each
group straight to its matching octal digit, using this table:

  000 -> 0   010 -> 2   100 -> 4   110 -> 6
  001 -> 1   011 -> 3   101 -> 5   111 -> 7

WHY the integer and fractional parts are grouped from DIFFERENT
directions:
Place values count outward from the binary point in both directions:
1s, 2s, 4s... to the LEFT, and 1/2s, 1/4s, 1/8s... to the RIGHT.
Groups of 3 bits have to line up with where the point actually is, so
the integer part is grouped starting AT the point and moving left
(padding extra zeros on the far left if needed), while the
fractional part is grouped starting AT the point and moving right
(padding extra zeros on the far right if needed). Grouping from the
wrong end would misalign every digit after the first group.

WHY the exit key check works:
The ESC key sends a single control byte, \x1b (27 in decimal). We
read raw keyboard input (instead of a normal input() line, which
only reports a key after Enter) so that one byte can be caught the
instant it's pressed.
"""

import sys

ESC_KEY = b"\x1b"

BIT_GROUP_TO_OCTAL = {
    "000": "0", "001": "1", "010": "2", "011": "3",
    "100": "4", "101": "5", "110": "6", "111": "7",
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
    """Convert a binary integer string (no sign) to octal, printing each step."""
    if bits == "" or bits == "0":
        print("  Integer part is 0 -> octal: 0")
        return "0"

    pad = (3 - len(bits) % 3) % 3
    padded = "0" * pad + bits
    if pad:
        print(f"  Padded with {pad} leading zero(s) so the length divides evenly by 3: {padded}")
    else:
        print(f"  Length is already a multiple of 3: {padded}")

    groups = [padded[i:i + 3] for i in range(0, len(padded), 3)]
    print(f"  Grouped into 3s outward from the point (leftward): {' '.join(groups)}")

    digits = []
    for i, group in enumerate(groups, start=1):
        digit = BIT_GROUP_TO_OCTAL[group]
        digits.append(digit)
        print(f"    Group {i}: {group} -> {digit}")

    return "".join(digits)


def convert_fractional_part(bits):
    """Convert a binary fractional string (no sign, no leading '.') to octal."""
    if bits == "":
        return ""

    pad = (3 - len(bits) % 3) % 3
    padded = bits + "0" * pad
    if pad:
        print(f"  Padded with {pad} trailing zero(s) so the length divides evenly by 3: {padded}")
    else:
        print(f"  Length is already a multiple of 3: {padded}")

    groups = [padded[i:i + 3] for i in range(0, len(padded), 3)]
    print(f"  Grouped into 3s outward from the point (rightward): {' '.join(groups)}")

    digits = []
    for i, group in enumerate(groups, start=1):
        digit = BIT_GROUP_TO_OCTAL[group]
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


def binary_to_octal(raw):
    is_negative, integer_bits, fractional_bits = parse_binary(raw)

    display = f"{'-' if is_negative else ''}{integer_bits}" + (f".{fractional_bits}" if fractional_bits else "")
    print(f"Converting binary {display} to octal:\n")

    print("Integer part:")
    octal_integer = convert_integer_part(integer_bits)

    octal_fraction = ""
    if fractional_bits:
        print("\nFractional part:")
        octal_fraction = convert_fractional_part(fractional_bits)

    result = ("-" if is_negative else "") + octal_integer
    if octal_fraction:
        result += "." + octal_fraction

    print(f"\nFinal octal result: {result}")
    return result


if __name__ == "__main__":
    print("Binary to Octal Converter (handles negatives and fractions)")
    print("Press ESC after a conversion to quit, or any other key to go again.\n")

    while True:
        raw = input("Enter a binary number to convert (e.g. -101.011): ")
        try:
            result = binary_to_octal(raw)
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