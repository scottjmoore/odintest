package main

import "core:fmt"
import "vendor:raylib"

import "test"


main :: proc() {
    raylib.InitWindow(640, 512, "Odin - Raylib")
    defer raylib.CloseWindow()

    player_pos := raylib.Vector2 {320, 256}

    Player :: struct {
        pos: raylib.Vector2,
        size: raylib.Vector2,
        vel: raylib.Vector2,
        color: raylib.Color
    }
    //raylib.SetTargetFPS(60)

    player := Player {
        {320, 256},             // position
        {32, 32},               // size
        {0, 0},                 // velocity
        {160, 255, 0, 128}      // color
    }

    for !raylib.WindowShouldClose() {
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLUE)

        raylib.DrawRectangleV(player.pos, player.size, player.color)

        if raylib.IsKeyDown(.LEFT) {
            player.pos.x -= 400 * raylib.GetFrameTime()
        }
        if raylib.IsKeyDown(.RIGHT) {
            player.pos.x += 400 * raylib.GetFrameTime()
        }
        if raylib.IsKeyDown(.UP) {
            player.pos.y -= 400 * raylib.GetFrameTime()
        }
        if raylib.IsKeyDown(.DOWN) {
            player.pos.y += 400 * raylib.GetFrameTime()
        }

        if raylib.IsKeyDown(.W) {
            player.size.x -= 50 * raylib.GetFrameTime()
            player.size.y -= 50 * raylib.GetFrameTime()
        }

        if raylib.IsKeyDown(.S) {
            player.size.x += 50 * raylib.GetFrameTime()
            player.size.y += 50 * raylib.GetFrameTime()
        }

        if player.pos.x < 0 {
            player.pos.x = 0
        }
        if player.pos.x > f32(raylib.GetScreenWidth())-player.size.x {
            player.pos.x = f32(raylib.GetScreenWidth())-player.size.x
        }
        if player.pos.y < 0 {
            player.pos.y = 0
        }
        if player.pos.y > f32(raylib.GetScreenHeight())-player.size.y {
            player.pos.y = f32(raylib.GetScreenHeight())-player.size.y
        }

        raylib.DrawFPS(10, 10)
        raylib.EndDrawing()
    }
}