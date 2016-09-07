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
