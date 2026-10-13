"""
Binary to Decimal Converter — shows every step of the process.
Handles negative numbers and fractional binary numbers (e.g. 101.101),
loops until you press ESC, and copies the result to the clipboard using
only the standard library (no pip install needed).

WHY multiplying by powers of 2 works:
Binary is a base-2 place-value system. Each position has a weight that
is a power of 2, and a bit simply says whether that weight is "on" (1)
or "off" (0). So the decimal value is the sum of the weights of every
position that holds a 1:

  Integer side (counting LEFT from the point):   ... 16  8  4  2  1
                                                 ... 2^4 2^3 2^2 2^1 2^0
  Fraction side (counting RIGHT from the point): 1/2  1/4  1/8  1/16 ...
                                                 2^-1 2^-2 2^-3 2^-4 ...

Example: 101.101
  1x4 + 0x2 + 1x1 + 1x0.5 + 0x0.25 + 1x0.125 = 5.625

WHY the fractional part is always exact in decimal:
Every fractional weight 2^-n equals 5^n / 10^n, which is a finite
decimal (0.5, 0.25, 0.125, 0.0625, ...). So a binary fraction never
needs rounding when written in decimal. This script uses that fact to
work with whole-number math only, which avoids the tiny rounding
errors floating point numbers would introduce.

WHY the exit key check works:
The ESC key sends a single control byte, \x1b (27 in decimal). We
read raw keyboard input (instead of a normal input() line, which
only reports a key after Enter) so that one byte can be caught the
instant it's pressed.
"""

import sys

ESC_KEY = b"\x1b"


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
    """Convert a binary integer string (no sign) to a decimal int, printing each step."""
    if bits == "" or bits == "0":
        print("  Integer part is 0 -> decimal: 0")
        return 0

    print(f"  Position weights count LEFT from the point, starting at 2^0: {bits}")

    total = 0
    terms = []
    length = len(bits)
    for index, bit in enumerate(bits):
        power = length - 1 - index
        weight = 2 ** power
        term = int(bit) * weight
        total += term
        terms.append(str(term))
        print(f"    Bit {index + 1}: {bit} x 2^{power} ({weight}) = {term}")

    print(f"  Sum: {' + '.join(terms)} = {total}")
    return total


def convert_fractional_part(bits):
    """
    Convert a binary fractional string (no leading '.') to its exact
    decimal digits (the part after the '.'), printing each step.
    """
    if bits == "":
        return ""

    print(f"  Position weights count RIGHT from the point, starting at 2^-1: {bits}")

    terms = []
    for index, bit in enumerate(bits, start=1):
        # 2^-n == 5^n / 10^n, so its decimal digits are 5^n padded to n places.
        weight_digits = str(5 ** index).zfill(index)
        term_digits = weight_digits if bit == "1" else "0" * index
        if bit == "1":
            terms.append("0." + weight_digits)
        print(f"    Bit {index}: {bit} x 2^-{index} (0.{weight_digits}) = 0.{term_digits}")

    # Exact total using whole-number math: bits as an integer over 2^n,
    # rewritten as (value * 5^n) over 10^n.
    n = len(bits)
    digits = str(int(bits, 2) * 5 ** n).zfill(n).rstrip("0")

    if terms:
        print(f"  Sum: {' + '.join(terms)} = 0.{digits or '0'}")
    else:
        print("  Every fractional bit is 0, so the fractional part is 0.")

    return digits


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


def binary_to_decimal(raw):
    is_negative, integer_bits, fractional_bits = parse_binary(raw)

    display = f"{'-' if is_negative else ''}{integer_bits}" + (f".{fractional_bits}" if fractional_bits else "")
    print(f"Converting binary {display} to decimal:\n")

    print("Integer part:")
    dec_integer = convert_integer_part(integer_bits)

    dec_fraction = ""
    if fractional_bits:
        print("\nFractional part:")
        dec_fraction = convert_fractional_part(fractional_bits)

    result = ("-" if is_negative else "") + str(dec_integer)
    if dec_fraction:
        result += "." + dec_fraction

    print(f"\nFinal decimal result: {result}")
    return result


if __name__ == "__main__":
    print("Binary to Decimal Converter (handles negatives and fractions)")
    print("Press ESC after a conversion to quit, or any other key to go again.\n")

    while True:
        raw = input("Enter a binary number to convert (e.g. -1011.101): ")
        try:
            result = binary_to_decimal(raw)
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