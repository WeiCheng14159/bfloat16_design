import struct


def fp32tobf16(x):
    # Convert float to int representation
    bit_rep = struct.unpack('I', struct.pack('f', x))[0]

    exp = bit_rep & 0x7F800000  # 8-bit exponent field
    man = bit_rep & 0x007FFFFF  # 7-bit mantissa field

    if exp == 0 and man == 0:
        # zero
        return x

    if exp == 0x7F800000:
        # infinity or NaNs
        return x

    bit_rep &= 0xffff0000
    y = struct.unpack('f', struct.pack('I', bit_rep))[
        0]  # Convert int back to float

    return y


if __name__ == "__main__":
    for i in range(1, 9):
        print(fp32tobf16(2.0 + 2**-i))
