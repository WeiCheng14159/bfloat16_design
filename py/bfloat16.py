from fp32tobf16 import fp32tobf16
import struct


class bfloat16:
    def __init__(self, value):
        self.value = fp32tobf16(value)
        self.bit_rep = struct.unpack('I', struct.pack('f', self.value))[0]
        self.exp = (self.bit_rep & 0x7F800000) >> 23
        self.fp32_man = self.bit_rep & 0x007FFFFF
        self.bf16_man = (self.bit_rep & 0x007F0000) >> 16
        self.sign = (self.bit_rep & 0x80000000) >> 31

        
    def __add__(self, other):
        if isinstance(other, bfloat16):
            return bfloat16(self.value + other.value)
        return bfloat16(bfloat16(self.value) + bfloat16(other))

    def __sub__(self, other):
        if isinstance(other, bfloat16):
            return bfloat16(self.value - other.value)
        return bfloat16(bfloat16(self.value) - bfloat16(other))

    def __mul__(self, other):
        if isinstance(other, bfloat16):
            return bfloat16(self.value * other.value)
        return bfloat16(bfloat16(self.value) * bfloat16(other))

    def __truediv__(self, other):
        if isinstance(other, bfloat16):
            return bfloat16(self.value / other.value)
        return bfloat16(bfloat16(self.value) / bfloat16(other))

    def __str__(self):
        return str(self.value)

    def convert2bin(self):
        return format(self.sign, '1b') + format(self.exp, '08b') + format(self.bf16_man, '07b')

    def bin_str(self):
        return format(self.sign, '1b') + " " + format(self.exp, '08b') + " " + format(self.bf16_man, '07b')

    def convert2hex(self):
        return format((self.bit_rep & 0xFFFF0000) >> 16, '04X')


if __name__ == "__main__":
    a = bfloat16(2.015625)
    b = bfloat16(3.1)

    # Test addition
    print(f"{a} + {b} = {(a + b).value}")

    # Test subtraction
    print(f"{a} - {b} = {(a - b).value}")

    # Test multiplication
    print(f"{a} * {b} = {(a * b).value}")

    # Test division
    print(f"{a} / {b} = {(a / b).value}")

    # Test binary conversion
    print(f"Binary representation of {a} = {a.convert2bin()}")

    # Test bin_str function
    print(f"Binary string representation of {a} = {a.bin_str()}")

    # Test convert2hex function
    print(f"Hexadecimal representation of {a} = {a.convert2hex()}")
