import sys

ESC_KEY = b"\x1b"
MAX_FRACTION_BITS = 20  # safety cap for non-terminating fractions


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
    no pip install, no external package, nothing outside this file.

    WHY this works without a dependency:
    Every major OS already ships its own command-line clipboard tool
    (clip on Windows, pbcopy on macOS, xclip/xsel on Linux). Rather
    than pulling in a library that wraps these, we just call the tool
    itself via subprocess and pipe our text into its stdin — the same
    thing a library like pyperclip would do internally anyway.
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


def convert_integer_part(n):
    """Convert a non-negative whole number to binary, printing each step."""
    if n == 0:
        print("Integer part is 0 -> binary: 0")
        return "0"

    remainders = []
    print(f"Integer part ({n}) — repeatedly divide by 2:\n")

    step = 1
    value = n
    while value > 0:
        quotient = value // 2
        remainder = value % 2
        remainders.append(str(remainder))
        print(f"  Step {step}: {value} ÷ 2 = {quotient}  remainder {remainder}")
        value = quotient
        step += 1

    # First remainder found is the LAST bit of the answer, so reverse.
    binary_integer = "".join(reversed(remainders))
    print(f"\n  Read remainders BOTTOM to TOP: {binary_integer}")
    return binary_integer


def convert_fractional_part(frac):
    """Convert a fractional part (0 <= frac < 1) to binary, printing each step."""
    print(f"\nFractional part ({frac}) — repeatedly multiply by 2:\n")

    bits = []
    step = 1
    value = frac
    while value > 0 and step <= MAX_FRACTION_BITS:
        value *= 2
        bit = int(value)          # 1 if it crossed past 1, else 0
        value -= bit               # keep only what's left over
        bits.append(str(bit))
        print(f"  Step {step}: multiply by 2 -> {value + bit:.6f}  ->  bit {bit}, remainder {value:.6f}")
        step += 1

    if value > 0:
        print(f"  (Stopped after {MAX_FRACTION_BITS} bits — this fraction repeats forever in binary,")
        print(f"   the same way 1/3 repeats forever in decimal.)")

    binary_fraction = "".join(bits)
    print(f"\n  Read bits TOP to BOTTOM (the order they were found): {binary_fraction}")
    return binary_fraction


def decimal_to_binary(value):
    is_negative = value < 0
    value = abs(value)
    integer_part = int(value)
    fractional_part = value - integer_part

    print(f"Converting {'-' if is_negative else ''}{value} to binary:\n")

    binary_integer = convert_integer_part(integer_part)

    binary_fraction = ""
    if fractional_part > 0:
        binary_fraction = convert_fractional_part(fractional_part)

    binary_result = ("-" if is_negative else "") + binary_integer
    if binary_fraction:
        binary_result += "." + binary_fraction

    print(f"\nFinal binary result: {binary_result}")
    print(f"(Note: fractional binary-to-decimal conversion back is only approximate")
    print(f" once digits are cut off at {MAX_FRACTION_BITS} bits.)" if binary_fraction else "", end="")

    return binary_result


if __name__ == "__main__":
    print("Decimal to Binary Converter (handles negatives and fractions)")
    print("Press ESC after a conversion to quit, or any other key to go again.\n")

    while True:
        try:
            num = float(input("Enter a decimal number to convert (e.g. 25.789): "))
        except ValueError:
            print("That's not a valid number — try again.\n")
            continue

        result = decimal_to_binary(num)

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