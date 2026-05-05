import KanTactics

/-!
# TVM 257-bit Signed Integer

TVM's primary numeric stack value is a 257-bit signed integer
occupying the inclusive range `[-2^256, 2^256 - 1]`.  This module
defines the wrapped type `Int257` together with a smart constructor
that returns `none` for out-of-range candidates and never crashes.

The bound is encoded as a proof field on the structure so that any
`Int257` value carries evidence of its own well-formedness.  This
mirrors the Mi-Cho-Coq treatment of Tezos `int` values, with the
larger TVM range.

Arithmetic that can overflow the 257-bit range produces `Option Int257`
at the smart-constructor level rather than silently wrapping or
panicking.  The actual arithmetic operators are out of scope for the
scaffold and land in subsequent commits.
-/

namespace TvmLean4

/-- Inclusive lower bound of the TVM 257-bit signed integer range. -/
def Int257.lowerBound : Int := -(2 : Int) ^ 256

/-- Exclusive upper bound of the TVM 257-bit signed integer range. -/
def Int257.upperBound : Int := (2 : Int) ^ 256

/-- A TVM 257-bit signed integer.

    Witnessed by an underlying `Int` plus a proof that it lies in
    `[Int257.lowerBound, Int257.upperBound)`. -/
structure Int257 where
  val : Int
  inBounds : Int257.lowerBound <= val /\ val < Int257.upperBound

/-- Smart constructor.

    Returns `some` if the candidate falls within the 257-bit signed
    range and `none` otherwise.  Never crashes. -/
def Int257.ofInt? (n : Int) : Option Int257 :=
  if h : Int257.lowerBound <= n /\ n < Int257.upperBound then
    some ⟨n, h⟩
  else
    none

end TvmLean4
