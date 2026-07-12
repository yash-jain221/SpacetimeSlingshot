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

## Run it

1. Install Godot 4.7 (standard build).
2. From this folder run `godot --path . -e`, or open `project.godot` from the Godot Project Manager.
3. Press F5 to play.

## Tech

- Godot 4.7, Forward+ renderer
- GDScript
- 2.5D: 3D presentation with gameplay constrained to a plane
