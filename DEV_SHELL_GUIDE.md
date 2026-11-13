# Project dev shells

A dev shell supplies project-specific tools without replacing the workstation's
global versions. It is an environment, not an isolated container; use Docker
separately when a project needs containers or services.

This example provides **Node.js 24, TypeScript, and Go 1.25** for an
`x86_64-linux` project. Use only tools the project actually needs.

## 1. Add a flake

In the project directory, create `flake.nix` with:

```nix
{
  description = "Node, TypeScript, and Go development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          pkgs.nodejs_24
          pkgs.typescript
          pkgs.go_1_25
        ];
      };
    };
}
```

Don't overwrite an existing `flake.nix`: add a dev shell to it instead. The
package names choose Node and Go release lines; the exact builds come from the
Nixpkgs revision recorded in `flake.lock`.

## 2. Lock and enter the shell

For a Git project, add the new flake file to the index **before** running Nix:

```sh
git add flake.nix
```

Then create the lock file, enter the shell, and check the tools:

```sh
nix flake lock
nix develop
node --version
npm --version
tsc --version
go version
```

The first run may download packages. Run `exit` to leave the dev shell; your
normal global tool versions become available again. Commit `flake.nix` and
`flake.lock` with the project so others can use the same locked inputs.

## 3. Optional: load automatically with direnv

Create a project `.envrc` containing:

```sh
use flake
```

Review existing `.envrc` files rather than overwriting them. Approve only a
project you trust: `.envrc` can execute commands.

```sh
direnv allow
```

With Alien and `remote`'s Bash integration, entering the project directory
loads the environment and leaving unloads it. Add `.envrc` to Git if sharing
the setup, and add `.direnv/` to the project's `.gitignore` without replacing
existing ignore rules. The cache in `.direnv/` is local and should not be
committed.

## 4. Project dependencies and Neovim

- The shell provides tools; it does not install JavaScript or Go dependencies.
  Follow the project's existing `package.json`, npm lockfile, `go.mod`, and
  `go.sum` workflow. Dependency installation can download packages and change
  project files; review the project instructions first.
- The example provides a shell-level TypeScript compiler. A project can instead
  pin TypeScript in its own JavaScript dependencies; project scripts may select
  that local version. Check the version used by the project's build.
- The Go directive in `go.mod` sets the project's minimum Go version; it does
  not update the flake. Go may download another toolchain when its configuration
  allows it. Keep the shell's Go version compatible with the project.
- Start Neovim after entering the shell or after direnv loads it. Language
  servers inherit that environment; the global language-server versions still
  need to be compatible with the project toolchain.

## 5. Update a project's Nix tools

From the project directory, update only its Nixpkgs input, inspect the lock
change, and test the shell and project before committing:

```sh
nix flake update nixpkgs
git diff -- flake.lock
nix develop
```

Changing the Nixpkgs revision can update multiple tools. To change Node or Go
release lines, edit their package names in `flake.nix` as well, then test.
This project lock is independent of the workstation's `flake.lock`.
