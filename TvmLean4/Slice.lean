import TvmLean4.Cell

/-!
# TVM Slice

A `Slice` is a read cursor into a `Cell`: a triple of
`(cell, dataOffset, refOffset)` representing "the unconsumed suffix
of this cell starting from `dataOffset` data bits and `refOffset`
references."

Slices are the runtime mechanism by which both FunC and TVM bytecode
parse cell payloads.  A typical contract spends most of its decoding
budget walking a slice across an incoming message body.

The scaffold defines the type and shallow well-formedness only.
Bit- and ref-consuming operations (`loadInt`, `loadCell`, `loadRef`,
etc.) and proof-relevant lemmas about cursor monotonicity land in
subsequent commits.
-/

namespace TvmLean4

/-- A read cursor into a `Cell`.

    `dataOffset` is the index of the first not-yet-consumed bit.
    `refOffset` is the index of the first not-yet-consumed child
    reference.  Both must lie within the underlying cell's declared
    payload size; that bound is enforced by `Slice.WellFormed`. -/
structure Slice where
  cell : Cell
  dataOffset : Nat
  refOffset : Nat
  deriving Repr

/-- Shallow well-formedness for slices: offsets are within the cell's
    declared size.  Recursive sub-DAG well-formedness is added in a
    later commit. -/
def Slice.WellFormed : Slice -> Prop
  | ⟨c, d, r⟩ => d <= c.data.length /\ r <= c.refs.length

end TvmLean4
