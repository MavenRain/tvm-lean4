import TvmLean4.Word

/-!
# TVM Instruction subset (feasibility prototype)

A small subset of the TVM instruction set, sufficient to demonstrate
the shape of the small-step semantics and to support the toy worked
examples in `Example`.  Six instructions.

This file is part of the **feasibility prototype** scaffold.  The
full ~50-instruction formalisation, together with the
`step_deterministic` and `step_preserves_well_typed` Lean-checked
theorems, is the M1 deliverable of the proposed funded development
plan and is intentionally out of scope here.

The instructions implemented:

  * Stack manipulation: `pushInt`, `drop`, `dup`, `swap`.
  * Arithmetic: `add`, `sub`.

Each instruction is total over its required input shape.  Inputs
that violate the shape, including under-deep stacks, non-integer
top values, or arithmetic results that overflow the `Int257` range,
cause the step function to return `none` rather than to panic.
-/

namespace TvmLean4

/-- A small subset of TVM instructions used for the prototype.

    The full TVM instruction set covers roughly 1500 opcodes; this
    prototype implements 6 to demonstrate the framework's shape. -/
inductive Instruction : Type where
  /-- `PUSH n`: push the literal integer `n` onto the stack. -/
  | pushInt : Int257 -> Instruction
  /-- `DROP`: pop the top of the stack and discard it. -/
  | drop : Instruction
  /-- `DUP`: duplicate the top of the stack. -/
  | dup : Instruction
  /-- `SWAP`: exchange the top two elements of the stack. -/
  | swap : Instruction
  /-- `ADD`: pop two integers and push their sum. -/
  | add : Instruction
  /-- `SUB`: pop two integers and push their difference (lower minus
      top, in TVM's stack-bottom-minus-stack-top convention). -/
  | sub : Instruction

end TvmLean4
