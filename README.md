# CompOrgWithAI

A MASM (x86 Assembly) terminal Tic Tac Toe game using the Irvine32 library.

## Project Structure

- `tic_tac_toe.asm` - Main MASM source file containing game logic and procedures.
- `LICENSE` - MIT license for this project.
- `.gitignore` - Ignore rules for common MASM/Visual Studio build artifacts.

## Requirements

- MASM toolchain (ml / link)
- Irvine32 library (`Irvine32.inc` and `Irvine32.lib`)
- Windows command line environment

## Build and Run

Use your configured MASM + Irvine32 setup to assemble and run:

1. Assemble `tic_tac_toe.asm`
2. Link with Irvine32 libraries
3. Run the produced executable in a terminal

## Gameplay

- You play as `X`
- AI plays as `O`
- Enter a move from `1` to `9`
- First to complete a row, column, or diagonal wins
