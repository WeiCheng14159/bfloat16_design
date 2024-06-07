from bfloat16 import bfloat16

def get_pos_inf():
    return bfloat16(float('inf'))
def get_neg_inf():
    return bfloat16(float('-inf'))
def get_NaN():
    return bfloat16(float('nan'))
def get_pos_zero():
    return bfloat16(0.0)
def get_neg_zero():
    return bfloat16(-0.0)

def splice_bfloat_binary(str):
    sign = str[:1]
    exp = str[1:9]
    frac = str[9:]

    return sign, exp, frac

def mult_test(test_case='NaN_x_pos_inf'):
    if test_case == 'NaN_x_pos_inf':
        a = get_NaN()
        b = get_pos_inf()
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'NaN  x +Inf = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'NaN_x_neg_inf':
        a = get_NaN()
        b = get_neg_inf()
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'NaN  x -Inf = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'pos_inf_x_pos_0':
        a = get_pos_inf()
        b = get_pos_zero()
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'+Inf x +0   = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'pos_inf_x_neg_0':
        a = get_pos_inf()
        b = get_neg_zero()
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'+Inf x -0   = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'neg_inf_x_pos_0':
        a = get_neg_inf()
        b = get_pos_zero()
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'-Inf x +0   = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'neg_inf_x_neg_0':
        a = get_neg_inf()
        b = get_neg_zero()
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'-Inf x -0   = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'pos_inf_x_pos_num':
        a = get_pos_inf()
        b= bfloat16('0x1F81')
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'+Inf x +N   = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'pos_inf_x_neg_num':
        a = get_pos_inf()
        b= bfloat16('0x9F81')
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'+Inf x -N   = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'neg_inf_x_pos_num':
        a = get_neg_inf()
        b= bfloat16('0x1F81')
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'-Inf x +N   = {c.convert2hex()} = {s} | {e} | {f}')
    elif test_case == 'neg_inf_x_neg_num':
        a = get_neg_inf()
        b= bfloat16('0x9F81')
        c = a * b
        s, e, f = splice_bfloat_binary(c.convert2bin())
        print(f'-Inf x -N   = {c.convert2hex()} = {s} | {e} | {f}')
    else:
        print('bad input')

mult_test(test_case='NaN_x_pos_inf')
mult_test(test_case='NaN_x_neg_inf')
mult_test(test_case='pos_inf_x_pos_0')
mult_test(test_case='pos_inf_x_neg_0')
mult_test(test_case='neg_inf_x_pos_0')
mult_test(test_case='neg_inf_x_neg_0')
mult_test(test_case='pos_inf_x_pos_num')
mult_test(test_case='pos_inf_x_neg_num')
mult_test(test_case='neg_inf_x_pos_num')
mult_test(test_case='neg_inf_x_neg_num')