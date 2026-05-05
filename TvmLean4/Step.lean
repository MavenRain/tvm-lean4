import TvmLean4.Instruction
import TvmLean4.Stack

/-!
# TVM small-step semantics (feasibility prototype)

A partial step function from an `Instruction` and an input `Stack`
to an output `Stack`, returning `none` when the instruction cannot
fire on the given input shape.

This module is part of the **feasibility prototype** scaffold.  The
full small-step relation (covering ~50 contract-relevant
instructions) and the `step_deterministic` /
`step_preserves_well_typed` Lean-checked theorems are the M1
deliverable of the proposed funded development plan and are out of
scope here.

The step function uses `Option` combinators (`bind`, `map`) rather
than nested `match` arms wherever an arithmetic computation can
fail, in line with the project's combinator-over-pattern-matching
convention.
-/

namespace TvmLean4

/-- Project the integer payload of a stack value, if any.

    Returns `some` for `StackValue.int`, `none` for every other
    constructor.  Total. -/
def StackValue.toInt? : StackValue -> Option Int257
  | .int n => some n
  | .cell _ => none
  | .slice _ => none
  | .builder _ => none
  | .tuple _ => none
  | .cont => none
  | .null => none

/-- One-step semantics of a prototype TVM instruction.

    The shape `_ :: _ :: s` denotes a stack with at least two
    elements; the head is the top of stack.  Instructions whose
    required input shape is not met return `none`. -/
def Instruction.step : Instruction -> Stack -> Option Stack
  | .pushInt n, s => some (.int n :: s)
  | .drop, [] => none
  | .drop, _ :: s => some s
  | .dup, [] => none
  | .dup, x :: s => some (x :: x :: s)
  | .swap, [] => none
  | .swap, _ :: [] => none
  | .swap, x :: y :: s => some (y :: x :: s)
  | .add, [] => none
  | .add, _ :: [] => none
  | .add, x :: y :: s =>
      x.toInt?.bind fun a =>
        y.toInt?.bind fun b =>
          (Int257.ofInt? (a.val + b.val)).map fun r => .int r :: s
  | .sub, [] => none
  | .sub, _ :: [] => none
  | .sub, top :: lower :: s =>
      top.toInt?.bind fun a =>
        lower.toInt?.bind fun b =>
          (Int257.ofInt? (b.val - a.val)).map fun r => .int r :: s

/-- Run a sequence of instructions on an initial stack, threading
    `Option` through any failure.  Returns `none` if any step in
    the sequence fails; otherwise returns the final stack. -/
def Instruction.run : List Instruction -> Stack -> Option Stack
  | [], s => some s
  | i :: is, s => (i.step s).bind (Instruction.run is)

end TvmLean4
