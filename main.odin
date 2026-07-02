package main

import "core:fmt"
import "vendor:raylib"

import "test"

Player :: struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    vel: raylib.Vector2,
    jumping: bool,
    color: raylib.Color
}

PlayerCreate :: proc(pos: raylib.Vector2, size: raylib.Vector2, color: raylib.Color) -> Player {
   return Player {
        pos,
        size,
        {0,0},
        false,
        color
    }
}

Item :: struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    color: raylib.Color
}

main :: proc() {

    pos,vec : raylib.Vector2

    pos = {500,500}
    vec = {0,-500}

    raylib.InitWindow(640, 512, "Odin - Raylib")
    defer raylib.CloseWindow()

    //raylib.SetTargetFPS(60)

    player := PlayerCreate({320, 256}, {32, 32}, {160, 255, 0, 128})

    for !raylib.WindowShouldClose() {
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLUE)

        raylib.DrawRectangleV(player.pos, player.size, player.color)

        if raylib.IsKeyDown(.LEFT) {
            player.vel.x = -200
        } else if raylib.IsKeyDown(.RIGHT) {
            player.vel.x = 200
        } else {
            player.vel.x = 0
        }

        player.vel.y += 200 * raylib.GetFrameTime()

        if raylib.IsKeyDown(.SPACE) && player.jumping == false {
            player.vel.y = -200
            player.jumping = true
        }

        player.pos += (player.vel * raylib.GetFrameTime())

        if player.pos.x < 0 {
            player.pos.x = 0
        }
        if player.pos.x > f32(raylib.GetScreenWidth())-player.size.x {
            player.pos.x = f32(raylib.GetScreenWidth())-player.size.x
        }
        if player.pos.y < 0 {
            player.pos.y = 0
        }
        if player.pos.y >= f32(raylib.GetScreenHeight())-player.size.y {
            player.pos.y = f32(raylib.GetScreenHeight())-player.size.y
            player.vel.y = 0
            player.jumping = false;
        }

        raylib.DrawFPS(10, 10)
        raylib.EndDrawing() 
    }
}