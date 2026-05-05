import Lake
-- Lake configuration for tvm-lean4
--
-- Formal verification framework for the TON Virtual Machine (TVM)
-- and the FunC source language that compiles to it.
--
-- Depends on:
--   * kan-tactics -- proof tactic library, kan-extension based.
--
-- autoImplicit is disabled project-wide to avoid accidental
-- free-variable introduction.
open Lake DSL

package TvmLean4 where
  leanOptions := #[⟨`autoImplicit, false⟩]

@[default_target]
lean_lib TvmLean4 where
  srcDir := "."

require «kan-tactics» from git
  "https://github.com/MavenRain/kan-tactics.git" @ "5c238e121ca21cf296af3a4e7ee4f76103bb53e6"
