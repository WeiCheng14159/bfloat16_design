from fp32tobf16 import fp32tobf16
import struct


class bfloat16:
    def __init__(self, value):
        if isinstance(value, float):
            self.value = fp32tobf16(value)
            self.bit_rep = struct.unpack('I', struct.pack('f', self.value))[0]
            self.exp = (self.bit_rep & 0x7F800000) >> 23
            self.fp32_man = self.bit_rep & 0x007FFFFF
            self.bf16_man = (self.bit_rep & 0x007F0000) >> 16
            self.sign = (self.bit_rep & 0x80000000) >> 31
        elif isinstance(value, str):
            if value.startswith('0b') and len(value) == 18 and all(c in '01' for c in value[2:]):
                sign = int(value[2], 2)
                exp_with_bias = int(value[3:11], 2)
                mantissa = int(value[11:], 2) / 128.0
                
                pos_0 = (sign == 0 and exp_with_bias == 0 and mantissa == 0)
                neg_0 = (sign == 1 and exp_with_bias == 0 and mantissa == 0)
                NaN = (exp_with_bias == 255 and mantissa != 0)

                float_value = float('nan') if NaN else 0.0 if pos_0 else -0.0 if neg_0 else ((-1)**sign) * (1 + mantissa) * (2 ** (exp_with_bias - 127))
                self.__init__(float_value)
            elif value.startswith('0x') and len(value) == 6 and all(c in '0123456789abcdefABCDEF' for c in value[2:]):
                bin_string = bin(int(value, 16))[2:].zfill(16)
                self.__init__('0b' + bin_string)
            else:
                raise ValueError("Invalid input format. Please provide a valid 16-bit binary starting with 0b or a 4-digit hexadecimal number starting with 0x.")
        else:
            raise TypeError("Value must be a float, binary string, or hexadecimal string.")
        
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
