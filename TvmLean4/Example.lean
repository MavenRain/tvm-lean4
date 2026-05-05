import TvmLean4.Step

/-!
# Worked examples (feasibility prototype)

Toy demonstrations of the prototype step semantics in `Step`.  Each
example is a `def` that constructs an `Option Stack` evaluable at
compile time with the `#eval` command.

This module is part of the **feasibility prototype** scaffold.  The
M1 deliverable of the proposed funded development plan replaces
these examples with end-to-end Lean-checked proofs against the M1
step relation and adds the `step_deterministic` and
`step_preserves_well_typed` soundness theorems.

The examples follow TVM's stack-bottom-minus-stack-top convention
for `SUB`: the second-from-top is the minuend and the top is the
subtrahend.
-/

namespace TvmLean4

/-- Example: `PUSH 1; PUSH 2; ADD` on the empty stack.

    Expected result: `some [int 3]`. -/
def example_pushAdd : Option Stack :=
  (Int257.ofInt? 1).bind fun one =>
    (Int257.ofInt? 2).bind fun two =>
      Instruction.run [.pushInt one, .pushInt two, .add] []

/-- Example: `PUSH 5; PUSH 3; SUB` on the empty stack.

    Expected result: `some [int 2]`.  The first push (5) becomes
    the lower element, the second push (3) becomes the top, and
    `SUB` computes 5 - 3 per the lower-minus-top convention. -/
def example_pushSub : Option Stack :=
  (Int257.ofInt? 5).bind fun five =>
    (Int257.ofInt? 3).bind fun three =>
      Instruction.run [.pushInt five, .pushInt three, .sub] []

/-- Example: `PUSH 7; DUP; ADD` on the empty stack.

    Expected result: `some [int 14]`. -/
def example_pushDupAdd : Option Stack :=
  (Int257.ofInt? 7).bind fun seven =>
    Instruction.run [.pushInt seven, .dup, .add] []

end TvmLean4
