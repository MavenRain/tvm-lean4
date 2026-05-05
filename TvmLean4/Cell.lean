import TvmLean4.Word

/-!
# TVM Cell

A TVM cell is the canonical TON memory and storage construct.  Each
cell holds:

  * a payload of up to 1023 data bits, and
  * up to 4 references to child cells.

Cells form a directed acyclic graph.  Both contract code and contract
storage state are encoded as cell trees.

This module declares the type and exposes the architectural maxima
as named constants.  Bit-precise serialization, hash computation,
Merkle proof verification, and the recursive sub-DAG well-formedness
predicate are out of scope for the scaffold and live in subsequent
commits.
-/

namespace TvmLean4

/-- Maximum number of data bits a cell can hold. -/
def Cell.maxBits : Nat := 1023

/-- Maximum number of child references a cell can hold. -/
def Cell.maxRefs : Nat := 4

/-- A TVM cell: a payload of up to 1023 bits plus up to 4 child
    references.

    The data and refs are unconstrained at the type level here; the
    architectural caps are enforced separately by `Cell.WellFormed`. -/
inductive Cell : Type where
  | mk (data : List Bool) (refs : List Cell)

/-- Project the bit payload of a cell. -/
def Cell.data : Cell -> List Bool
  | .mk d _ => d

/-- Project the child reference list of a cell. -/
def Cell.refs : Cell -> List Cell
  | .mk _ r => r

/-- Shallow well-formedness: the cell satisfies its own data and
    reference count caps.  The recursive sub-DAG case is added in a
    later commit and uses `List.Forall Cell.WellFormed`. -/
def Cell.WellFormed : Cell -> Prop
  | .mk d r => d.length <= Cell.maxBits /\ r.length <= Cell.maxRefs

end TvmLean4
