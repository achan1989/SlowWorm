# Instruction Formats

There are a few high-level groups of instruction formats.  The following list shows the groups, with their associated instruction bits `[2..0]`.

* Microcoded Instructions `[111]`
* Directly Encoded Instructions
  * Subroutine Call `[--0]`
  * Immediate Value `[001]`.  Do something with a small constant.
  * Logic `[011]`.  Perform operations with the ALU.
  * Control `[101]`.  Conditional jumps, returns, etc.

## Microcoded Instruction

| 15 - 3 | 2 | 1 | 0 |
| :---: | --- | --- | --- |
| `operation` | 1 | 1 | 1 |

## Subroutine Call

Subroutines **must** start at an even address (LSB is 0).

| 15 - 1 | 0 |
| :---: | --- |
| `subroutine address` (15 downto 1) | 0 |

A subroutine call is made by giving the address of the subroutine as the instruction.  The zero in the LSB of the instruction denotes the subroutine call.

The following operations take place:
* The value of the program counter is pushed to the return stack.
* The program counter is set to the subroutine address encoded in the instruction.
* The subroutine address is put on the instruction memory address bus.
* The next state is set to `Fetch`.

## Immediate Value

| 15 - 4 | 3 | 2 | 1 | 0 |
| :---: | :---: | --- | --- | --- |
| `value` | `stack` | 0 | 0 | 1 |

A 12-bit two's complement `value` (-2048 to 2047) is sign-extended and pushed to the selected `stack`.

| `stack` bit | selects |
| :---: | :---: |
| 0 | data |
| 1 | return |

Specifically, these operations take place:
* `value` is sign-extended to 16 bits.
* The extended value is placed on the appropriate stack's write bus.
* The appropriate stack's push signal is set high.
* The value of the program counter is put on the instruction memory address bus.
* The next state is set to `Fetch`.

## Logic

| 15 | 14 | 4 - 13 | 7 - 3 | 2 | 1 | 0 |
| :---: | :---: | :---: | :---: | --- | --- | --- |
| `stack` | `pop` | - | `operation` | 0 | 1 | 1 |

Performs arithmetic or logic operations on the top element(s) of the selected `stack`, and pushes the result onto the `stack`.
Can optionally `pop` the top element off the stack before the result is pushed.

In the following descriptions, `A` refers to the top element in the stack and `B` refers to the second element.

Logic operations are as follows:

| `operation` | performs |
| :---: | :---: |
| 00000 | not A |
| 00001 | not B |
| 00010 | A and B |
| 00011 | A nand B |
| 00100 | A or B |
| 00101 | A nor B |
| 00110 | A xor B |
| 00111 | A xnor B |
| 01000 | (not A) and B |
| 01001 | (not B) and A |
| 01010 | (not A) or B |
| 01011 | (not B) or A |

Arithmetic operations are as follows:

| `operation` | performs |
| :---: | :---: |
| 10000 | A plus B |
| 10001 | B minus A |
| 10010 | increment A |
| 10011 | increment B |
| 10100 | decrement A |
| 10101 | decrement B |
| 10110 | logical shift left A |
| 10111 | logical shift left B |
| 11000 | logical shift right A |
| 11001 | logical shift right B |
| 11010 | arithmetic shift right A |
| 11011 | arithmetic shift right B |
