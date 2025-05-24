# 🤖 Machine Instructions

**Machine Instructions** is a 2D puzzle game where you program a cute robot to escape deadly mazes.  You only get one turn to issue commands — so plan carefully!

*Originally made for Mini Code For A Cause #1, 3 days game jam.*

## 🧠 Concept

You are an engineer guiding C-4AC, a robot sent into mysterious catacombs.
Craft a single set of machine instructions using modular components, crossed-fingers hope it gets through the maze.

- 🎮 Genre: Puzzle / Maze / Logic
- 🎯 Core Mechanic: One-shot instruction crafting
- 🧩 Objective: Reach the exit of each handcrafted maze
- 🎨 Style: Top-down pixel art with cutesy robot aesthetics

## 🕹️ How to Play

1. Preview the maze layout.
2. Drag and drop command modules (e.g. move, turn) to form one instruction set.
3. Hit **RUN** and watch your robot follow your code.
4. Succeed or fail based on your logic!

> "You only get one shot — do not miss your chance to code."

## ✨ MVP Features

- [x] few handcrafted levels
- [x] Drag-and-drop instruction builder
- [x] Simple tile-based maze with collisions
- [x] Win/Fail logic
- [x] Restart and next level system
- [x] Cross-compilation ready

## 📷 Screenshots

_(Coming soon!)_

## 🔧 Built With

- 👑 Language: Nim
- 🧱 Library: Raylib
- 🎨 Pixel Art: Custom sprites
- 🧠 Game Jam Theme: "You Only Get One"

## 🆕 Releases

Official releases on [ITCH](https://pixelsane.itch.io/machine-instructions).

## 🚀 Build

Clone and run:

```bash
git clone https://github.com/pixelsane/machineinstructions
cd machine-instructions
nimble winrun # windows
nimble runr # platform compatible (x86_64 / AMD)
nimble webr # web, run your own server

# Follow setup/run instructions by looking through `machineinstructions.nimble`
