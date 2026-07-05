package odintest

import "core:fmt"
import "core:math"
import "vendor:raylib"

Item :: struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    color: raylib.Color
}

main :: proc() {

    raylib.SetConfigFlags({.MSAA_4X_HINT})
    raylib.InitWindow(640, 512, "Odin - Raylib")
    defer raylib.CloseWindow()

    raylib.SetTargetFPS(60)

    player := PlayerCreate({320, 256}, {32, 32}, {160, 255, 255, 200})

    items: [dynamic]Item
    defer delete(items)

    append(&items, Item{{100, 100}, {16, 16}, {255, 255, 0, 255}})
    append(&items, Item{{540, 100}, {16, 16}, {255, 255, 0, 255}})
    append(&items, Item{{540, 412}, {16, 16}, {255, 255, 0, 255}})
    append(&items, Item{{100, 412}, {16, 16}, {255, 255, 0, 255}})

    for !raylib.WindowShouldClose() {
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLUE)

        for item in items {
            raylib.DrawRectangleV(item.pos, item.size, item.color)
        }

        PlayerDraw(player)

        left : raylib.Vector2 = {raylib.GetGamepadAxisMovement(0, .LEFT_X), raylib.GetGamepadAxisMovement(0, .LEFT_Y)}
        right : raylib.Vector2 = {raylib.GetGamepadAxisMovement(0, .RIGHT_X), raylib.GetGamepadAxisMovement(0, .RIGHT_Y)}

        deadzone : raylib.Vector2 = {0.2, 0.2}

        if left.x < deadzone.x && left.x > -deadzone.x {
            left.x = 0
        }
        if left.y < deadzone.y && left.y > -deadzone.y {
            left.y = 0
        }

        if right.x < deadzone.x && right.x > -deadzone.x {
            right.x = 0
        }
        if right.y < deadzone.y && right.y > -deadzone.y {
            right.y = 0
        }

        if raylib.IsKeyDown(.LEFT) {
                player.vel.x -= max_speed * raylib.GetFrameTime()
            } else if raylib.IsKeyDown(.RIGHT) {
                player.vel.x += max_speed * raylib.GetFrameTime()
            }

        player.vel += (left * 100)

        max_speed :: 200

        if player.vel.x > max_speed {
            player.vel.x = max_speed
        } else if player.vel.x < -max_speed {
            player.vel.x = -max_speed
        }

        if player.vel.y > max_speed {
            player.vel.y = max_speed
        } else if player.vel.y < -max_speed {
            player.vel.y = -max_speed
        }

        player.vel -= (player.vel - (player.vel * 0.9))
        player.pos += (player.vel * raylib.GetFrameTime())
        
        angle := math.to_degrees(math.atan2(left.x, -left.y))
        player.angle = math.to_degrees(math.atan2(right.x, -right.y))

        screen_width := f32(raylib.GetScreenWidth())
        screen_height := f32(raylib.GetScreenHeight())

        if player.pos.x < player.size.x {
            player.pos.x = player.size.x
            player.vel.x = -player.vel.x
        }
        if player.pos.x > screen_width-player.size.x {
            player.pos.x = screen_width-player.size.x
            player.vel.x = -player.vel.x
        }
        if player.pos.y < player.size.y {
            player.pos.y = player.size.y
            player.vel.y = -player.vel.y
        }
        if player.pos.y >= screen_height-player.size.y {
            player.pos.y = screen_height-player.size.y
            player.vel.y = -player.vel.y
        }

        when ODIN_DEBUG {
            raylib.DrawFPS(10, 10)
        }

        raylib.EndDrawing() 
    }
}