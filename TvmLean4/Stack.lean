import TvmLean4.Word
import TvmLean4.Cell
import TvmLean4.Slice

/-!
# TVM Stack

TVM is a stack machine; each instruction consumes and produces a
sequence of typed `StackValue`s.  The full TVM value lattice covers
seven cases: integer, cell, slice, builder, continuation, tuple, and
null.

This module declares the sum type and the empty stack.  Push, pop,
swap, type-check predicates, and the per-instruction stack-shape
specifications are out of scope for the scaffold and land in
subsequent commits.

The architectural maximum stack depth (around 255 in practice) is
not encoded at the type level here; it is enforced separately by a
predicate added later.
-/

namespace TvmLean4

/-- The set of values that can appear on the TVM stack.

    Tuples are heterogeneous lists of stack values, which makes
    `StackValue` a nested inductive type (it appears under `List`).

    The `cont` constructor will eventually carry a closure capturing
    code and a snapshot of stack and control state; for the scaffold
    it is a placeholder constructor with no payload. -/
inductive StackValue : Type where
  | int : Int257 -> StackValue
  | cell : Cell -> StackValue
  | slice : Slice -> StackValue
  | builder : Cell -> StackValue
  | tuple : List StackValue -> StackValue
  | cont : StackValue
  | null : StackValue

/-- A TVM stack, with the head of the list as the top of stack. -/
abbrev Stack : Type := List StackValue

/-- The empty stack. -/
def Stack.empty : Stack := []

end TvmLean4
