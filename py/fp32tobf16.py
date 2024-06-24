import struct


def fp32tobf16(x):
    if isinstance(x, float):
        bit_rep = struct.unpack('I', struct.pack('f', x))[0]
        bit_rep &= 0xffff0000
        y = struct.unpack('f', struct.pack('I', bit_rep))[
            0]
        return y
    if isinstance(x, str):
        if x.startswith('0b') and len(x) == 18 and all(c in '01' for c in x[2:]):
            bin_bit_rep = int((x[2:] + '0' * 16), 2)
            bin_to_float = struct.unpack('f', struct.pack('I', bin_bit_rep))[0]
            return bin_to_float
        elif x.startswith('0x') and len(x) == 6 and all(c in '0123456789abcdefABCDEF' for c in x[2:]):
            hex_bit_rep = int((x[2:] + '0' * 4), 16)
            hex_to_float = struct.unpack('f', struct.pack('I', hex_bit_rep))[0]
            return hex_to_float
        else:
                raise ValueError("Invalid input format. Please provide a valid 16-bit binary starting with 0b or a 4-digit hexadecimal number starting with 0x.")
    else:
        raise TypeError("Value must be a float, binary string, or hexadecimal string.")


if __name__ == "__main__":
    for i in range(1, 9):
        print(fp32tobf16(2.0 + 2**-i))
