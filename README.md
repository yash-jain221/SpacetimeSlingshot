# Spacetime Slingshot

A 2.5D gravity-slingshot game built in Godot 4.7. Launch a ship and use the
gravity of planets, asteroids, and black holes to bend its trajectory toward a
destination planet.

## Status

Early development / work in progress.

## Plan

- Custom N-body gravity simulation (not the engine's built-in gravity)
- Drag-to-aim launching with a live predicted trajectory
- Goals, win/lose, and hand-built levels
- A bending "spacetime grid" visualization
- Procedurally shaded planets, asteroids, and a sun
- Black hole with gravitational lensing and time dilation
- Polish: particles, audio, menus, and an exported build

## Design

Architecture and design rationale will be documented in `DESIGN.md` (coming soon).

## Run it

1. Install Godot 4.7 (standard build).
2. From this folder run `godot --path . -e`, or open `project.godot` from the Godot Project Manager.
3. Press F5 to play.

## How to play

Launch a ship and use the planets' gravity to curve it into the green goal planet — without
smashing into the others. You don't aim straight at the goal; you aim so gravity *bends* you
into it.

- **Aim:** click and hold near the ship and drag to pull it back, like drawing a slingshot.
- **Read the arc:** a line shows the exact path the ship will take, curving around each planet.
  Pull further for more power (a longer arc); change the angle to bend the path differently.
- **Fire:** release the mouse. The ship flies along that predicted curve under gravity.
- **Win:** reach the **green** planet.
- **Lose:** crash into any other planet.
- **Retry:** click *Retry* to reset and try again.
- **Full N-body toggle:** the checkbox turns on "chaos mode" — planets start pulling on *each
  other*, not just the ship. Fun to watch, much harder to aim.

Tip: watch the predicted line and adjust *before* you release — a small change in pull can be
the difference between a clean capture and flying off into space.

## Tech

- Godot 4.7, Forward+ renderer
- GDScript
- 2.5D: 3D presentation with gameplay constrained to a plane
