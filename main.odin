package main

import "core:fmt"
import "vendor:raylib"

import "test"


main :: proc() {
    raylib.InitWindow(640, 512, "Odin - Raylib")

    for !raylib.WindowShouldClose() {
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.WHITE)
        raylib.EndDrawing()
    }

    raylib.CloseWindow()
}