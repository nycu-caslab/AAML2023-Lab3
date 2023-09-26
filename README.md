# AAML2023 Lab3


Brief introduction of Lab3


## Directory Structure
```bash
.
├── data_generator.py
├── Makefile
├── README.md
├── RTL
│   ├── global_buffer.v
│   └── TPU.v
└── TESTBENCH
    ├── PATTERN.v
    └── TESTBENCH.v
```

- `RTL`: The source code of your design
- `TESTBENCH`: The testbench to test your design.
- `data_generator.py`: The generator to generate the test case.


## Makefile
- `make verif1`
    - Run the code with #1 test case.
- `make verif2`
    - Run the code with #2 test case.
- `make verif3`
    - Run the code with #3 test case.
- `make real`
    - RUn the code with #4 test case.


