# tvm-lean4

A Lean 4 formal verification framework for the TON Virtual Machine
(TVM) and the FunC source language that compiles to it.

## Motivation

TON's smart contract auditing landscape is empirically nascent.
Yanovich et al. (arXiv 2509.10823, revised 2026-04-16) catalog 233
real-world vulnerabilities across 34 audit reports and observe that
TON-specific concerns, asynchronous message handling chief among
them, do not map cleanly onto Ethereum auditing patterns.

CertiK formally verified TON's masterchain `elector` and `config`
contracts ahead of mainnet by manually translating FunC into Coq;
that effort caught two concrete bugs but was never released as a
reusable tool.  No public, lakefile-installable formal verification
framework exists for TVM bytecode or FunC source.

`tvm-lean4` is intended as that framework: a Lean 4 sibling of
Tezos's Mi-Cho-Coq, packaged as a reservoir-style dependency that
contract authors can `require` from their own lakefile and use to
prove safety properties about contracts they have written.

## Architecture

```
TvmLean4/
  Word.lean         Int257, smart constructor for the 257-bit signed range
  Cell.lean         TVM cell type, architectural maxima, well-formedness
  Slice.lean        read cursor into a cell
  Stack.lean        heterogeneous stack value sum type
  Message.lean      internal message envelope, bounce flag, address
  Instruction.lean  six-instruction subset (feasibility prototype)
  Step.lean         partial step function for the prototype
  Example.lean      three worked examples evaluable with #eval
```

The first five modules are the type-level scaffold.  The last three
form a deliberately small **feasibility prototype** of the step
semantics; see the dedicated section below for the scope distinction
between the prototype and the funded M1 deliverable.

Subsequent commits cover serialization, hashing, the full
instruction set, the funded small-step relation, the inter-shard
delivery model, and a contract specification language inspired by
Mi-Cho-Coq's Hoare-triple encoding.

## Feasibility prototype vs M1 deliverable

The repository today contains a **feasibility prototype** of the
TVM step semantics.  The prototype is intentionally narrow:

* **Six instructions only.**  `pushInt`, `drop`, `dup`, `swap`,
  `add`, `sub`.  Out of roughly 1500 TVM opcodes.
* **Step function, not step relation.**  The semantics is encoded
  as a `Stack -> Option Stack` function rather than as an inductive
  proposition.  This is enough to evaluate examples but is not the
  proof-friendly form a contract verifier needs.
* **No theorems.**  In particular, no `step_deterministic` and no
  `step_preserves_well_typed`.

The funded **M1 deliverable** (per the bounty proposal at
https://github.com/ton-society/grants-and-bounties/issues, "tvm-lean4
- Lean 4 Formal Verification Framework for TVM and FunC") supersedes
the prototype with:

* **All ~50 contract-relevant instructions**, covering stack
  manipulation, arithmetic, control flow, comparison, cell
  operations, and the cryptographic primitives used by standard
  Jetton, NFT, and DEX contracts.
* **A small-step relation** as an inductive proposition, suitable
  for proof-relevant case analysis.
* **Lean-checked theorems**: `step_deterministic` and
  `step_preserves_well_typed`.

The prototype exists to demonstrate the framework's shape in
public, not to deliver any milestone of the funded plan.

## Conventions

* `autoImplicit` is off project-wide.  No accidental free variables.
* Tactic blocks use `kan-tactics` exclusively.  No standard Lean 4
  tactics in any `by` block.  Term-mode proof terms are fine.
* No exceptions: partial functions return `Option`, fallible parsers
  return `Except`.  No `panic!`, no `unreachable!`.
* Reusable lakefile dependency.  Other projects depend on this repo
  by adding a `require «tvm-lean4» from ...` line to their lakefile.

## Building

```sh
lake update
lake build
```

`lean-toolchain` pins the toolchain to `leanprover/lean4:v4.30.0-rc1`.
Adjust if your installed toolchain differs.

## Depending on this library

```lean
require «tvm-lean4» from git
  "https://github.com/MavenRain/tvm-lean4.git" @ "main"
```

## License

Dual-licensed under MIT OR Apache-2.0, at your option.
