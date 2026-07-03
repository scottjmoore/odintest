package odintest

import "vendor:raylib"

Item :: struct {
    pos: raylib.Vector2,
    size: raylib.Vector2,
    color: raylib.Color
}

main :: proc() {

    raylib.InitWindow(640, 512, "Odin - Raylib")
    defer raylib.CloseWindow()

    raylib.SetTargetFPS(60)

    player := PlayerCreate({320, 256}, {16, 16}, {160, 255, 255, 200})

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

        raylib.DrawTriangle(player.pos + {-16, 16}, player.pos + {16, 16}, player.pos + {0, -16}, player.color)

        if player.jumping == false {
            if raylib.IsKeyDown(.LEFT) {
                player.vel.x -= 800 * raylib.GetFrameTime()
            } else if raylib.IsKeyDown(.RIGHT) {
                player.vel.x += 800 * raylib.GetFrameTime()
            } else {
                player.vel.x *= 0.95 * (1-raylib.GetFrameTime())
            }
            if player.vel.x > 200 {
                player.vel.x = 200
            } else if player.vel.x < -200 {
                player.vel.x = -200
            }
        } else {
            player.vel.x *= 0.9999999 * (1-raylib.GetFrameTime())
        }

            
        if raylib.IsKeyDown(.SPACE) && player.jumping == false {
            player.vel.y = -200
            player.jumping = true
        }


        player.vel.y += 200 * raylib.GetFrameTime()
        player.pos += (player.vel * raylib.GetFrameTime())

        screen_width := f32(raylib.GetScreenWidth())
        screen_height := f32(raylib.GetScreenHeight())

        if player.pos.x < 0 {
            player.pos.x = 0
        }
        if player.pos.x > screen_width-player.size.x {
            player.pos.x = screen_width-player.size.x
        }
        if player.pos.y < 0 {
            player.pos.y = 0
        }
        if player.pos.y >= screen_height-player.size.y {
            player.pos.y = screen_height-player.size.y
            player.vel.y = 0
            player.jumping = false;
        }

        when ODIN_DEBUG {
            raylib.DrawFPS(10, 10)
        }

        raylib.EndDrawing() 
    }
}