package odintest

import "core:fmt"
import "core:math"
import "vendor:raylib"

Item :: struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    color: raylib.Color,
    collected: bool
}

main :: proc() {
    entities: [dynamic]rawptr
    defer delete(entities)

    raylib.SetConfigFlags({.MSAA_4X_HINT})
    raylib.InitWindow(640, 512, "Odin - Raylib")
    defer raylib.CloseWindow()

    raylib.SetTargetFPS(60)

    shadow_texture := raylib.LoadRenderTexture(640, 512)
    defer raylib.UnloadRenderTexture(shadow_texture)
    raylib.SetTextureFilter(shadow_texture.texture, .BILINEAR)

    player := PlayerCreate(320, 256, 32)
    player2 := PlayerCreate(320, 256, 32)
    
    append(&entities, &player)
    append(&entities, &player2)

    items: [dynamic]Item
    defer delete(items)

    append(&items, Item{{100, 100}, {16, 16}, {255, 255, 0, 255}, false})
    append(&items, Item{{540, 100}, {16, 16}, {255, 255, 0, 255}, false})
    append(&items, Item{{540, 412}, {16, 16}, {255, 255, 0, 255}, false})
    append(&items, Item{{100, 412}, {16, 16}, {255, 255, 0, 255}, false})
    append(&items, Item{{200, 200}, {16, 16}, {255, 255, 0, 255}, false})
    append(&items, Item{{440, 200}, {16, 16}, {255, 255, 0, 255}, false})
    append(&items, Item{{440, 312}, {16, 16}, {255, 255, 0, 255}, false})
    append(&items, Item{{200, 312}, {16, 16}, {255, 255, 0, 255}, false})

    for !raylib.WindowShouldClose() {
        raylib.BeginTextureMode(shadow_texture)
        for item in items {
            if !item.collected {
                raylib.DrawRectangleV((item.pos * {1, -1}) + {8, 490}, item.size, item.color)
            }
        }
        raylib.ClearBackground({0, 0, 0, 0})
        p := player
        p.pos *= {1, -1}
        p.pos += {16, 500}
        p.angle *= -1
        p.angle += 180
        p.Draw(&p)
        raylib.EndTextureMode()

        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLUE)
        raylib.DrawTexture(shadow_texture.texture, 0, 0, {0, 0, 0, 64})
        
        for item in items {
            if !item.collected {
                raylib.DrawRectangleV(item.pos, item.size, item.color)
            }
        }

       
        for rp in entities {
            e := cast(^Entity)rp
            e.Draw(e)
        }

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

        raylib.DrawText(raylib.TextFormat("Health: %08i", player.health), 12, 12, 20, raylib.BLACK)
        raylib.DrawText(raylib.TextFormat("Health: %08i", player.health), 10, 10, 20, raylib.GREEN)

        when ODIN_DEBUG {
            raylib.DrawFPS(10, 480)
        }

        raylib.EndDrawing() 

        for &item in items {
            if raylib.Vector2Distance(player.pos, item.pos) < 32 {
                if !item.collected {
                    player.health += 100
                }

                item.collected = true
            }
        }
    }
}