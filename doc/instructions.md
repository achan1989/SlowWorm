# Instruction Formats

There are a few high-level groups of instruction formats.  The following list shows the groups, with their associated instruction bits `[2..0]`.

* Microcoded Instructions `[111]`
* Directly Encoded Instructions
  * Subroutine Call `[--0]`
  * Immediate Value `[001]`.  Do something with a small constant.
  * Logic `[011]`.  Perform operations with the ALU.
  * Control `[101]`.  Conditional jumps, returns, etc.

## Microcoded Instruction

Bits `[2..0]` are `[111]`.
The rest of the instruction denotes the microcode operation to be performed.

## Subroutine Call

Subroutines must start at an even address (LSB == 0).

A subroutine call is made by giving the address of the subroutine as the instruction.  The zero in the LSB of the instruction denotes the subroutine call.
