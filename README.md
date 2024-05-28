# bfloat16 floating point unit (FPU)
This repo contains Verilog implementation of floating point unit (FPU) for
Google's [bfloat16](https://en.wikipedia.org/wiki/Bfloat16_floating-point_format) format.

## Dependency
- RTL simulator: ncverilog, iverilog
- Design synthesis: Design Compiler
- Place and route: Innovus, IC Compiler

## Generate testbench 
Generate inputs, addition, subtraction, multiplication, division results for bfloat16

```cd py/; python3 gen_tb.py --num 1000```

Copy generated *.txt files to ```sim/``` directory

```cp *.txt ../sim```

## RTL simulation 
This repo support both ncverilog & iverilog RTL simulator.

```make rtl0 RTL_SIM=ncverilog```

OR

```make rtl0 RTL_SIM=iverilog```

## Design synthesis
```make synthesize```

## Gate-level simulation
```make syn0 RTL_SIM=ncverilog```
