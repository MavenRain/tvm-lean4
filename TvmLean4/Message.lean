import TvmLean4.Word
import TvmLean4.Cell

/-!
# TVM Internal Messages

TON contracts communicate exclusively by asynchronous messages.  An
internal message envelope carries source and destination addresses,
TON-coin value, bounce semantics, timestamps, and a cell body
containing the call payload.

The asynchronous, message-based execution model is the principal
place where TON contracts diverge from EVM contracts.  Verification
of TON contracts must reason about message ordering, bounce-on-
failure, and replay across multiple shards, in addition to the
intra-contract control flow that EVM-style verifiers already
handle.

This module declares the envelope type only.  Validity predicates,
serialization to cells, fee accounting, and the inter-shard delivery
model are deferred to subsequent commits.
-/

namespace TvmLean4

/-- A TON workchain identifier.  `-1` denotes the masterchain; `0`
    denotes the base workchain; other values are reserved by the
    protocol. -/
abbrev WorkchainId : Type := Int

/-- A 256-bit account hash within a workchain. -/
abbrev AccountHash : Type := List Bool

/-- A TON account address: workchain plus 256-bit hash. -/
structure Address where
  workchain : WorkchainId
  hash : AccountHash

/-- Bounce semantics for an internal message.

  * `noBounce` means the destination must accept-or-burn the value.
  * `bounceable` means a failed delivery is returned to the sender.
  * `bounced` flags a message that is already a bounce-back of a
    previous failed delivery; bounced messages must not bounce again. -/
inductive BounceFlag : Type where
  | noBounce : BounceFlag
  | bounceable : BounceFlag
  | bounced : BounceFlag

/-- The full internal-message envelope.  Mirrors the on-chain TL-B
    schema for `Message X` over an `int_msg_info` case.

    `value` is in nanoton units, carried as `Int257`; an additional
    extra-currency map is omitted from the scaffold and added with
    the dictionary primitives in a later commit. -/
structure InternalMessage where
  src : Address
  dst : Address
  value : Int257
  bounce : BounceFlag
  createdLt : Nat
  createdAt : Nat
  body : Cell

end TvmLean4
