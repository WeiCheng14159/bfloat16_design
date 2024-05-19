from bfloat16 import bfloat16
import argparse
import random


def gen_input(num):
    a_vec = [x/10000 for x in random.sample(range(-10000, 10001), num)]
    b_vec = [x/10000 for x in random.sample(range(-10000, 10001), num)]

    in1_f = open("INPUT_A.txt", 'w')
    in2_f = open("INPUT_B.txt", 'w')

    for i in range(num):
        a = bfloat16(a_vec[i])
        b = bfloat16(b_vec[i])

        in1_f.write(a.convert2hex() + " // " + str(a) + "\n")
        in2_f.write(b.convert2hex() + " // " + str(b) + "\n")

    return a_vec, b_vec


def gen_results(op, num, a_vec, b_vec):
    all_options_str = "all"

    mul_f = open("MUL.txt", 'w')
    add_f = open("ADD.txt", 'w')
    sub_f = open("SUB.txt", 'w')
    div_f = open("DIV.txt", 'w')

    for i in range(num):
        a = bfloat16(a_vec[i])
        b = bfloat16(b_vec[i])

        if op == "MUL" or op == all_options_str:
            c = a * b
            mul_f.write(c.convert2hex() + " // " + str(c) + ("" if i == num-1 else "\n"))
        if op == "ADD" or op == all_options_str:
            c = a + b
            add_f.write(c.convert2hex() + " // " + str(c) + ("" if i == num-1 else "\n"))
        if op == "SUB" or op == all_options_str:
            c = a - b
            sub_f.write(c.convert2hex() + " // " + str(c) + ("" if i == num-1 else "\n"))
        if op == "DIV" or op == all_options_str:
            try: 
                c = a / b
            except: 
                c = bfloat16(float('inf'))
            div_f.write(c.convert2hex() + " // " + str(c) + ("" if i == num-1 else "\n"))


def gen_tb(op, num):
    a_vec, b_vec = gen_input(num)
    gen_results(op, num, a_vec=a_vec, b_vec=b_vec)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Generate test cases for bfloat16')
    parser.add_argument('--num', type=int, default=10,
                        help='Number of samples to generate.')
    parser.add_argument('--op', type=str, default="all", choices=["MUL", "ADD", "all"],
                        help='What operations is performed on bfloat16 (e.g. MUL, ADD)')
    args = parser.parse_args()

    assert args.num <= 10000, "Number of samples should be <= 10000"

    gen_tb(args.op, args.num)
