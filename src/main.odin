package odintest

import "core:fmt"
import "core:math"
import "vendor:raylib"

import "assets/graphics/bitmaps"

main :: proc() {

    MyGameData :: struct {
        score: int
    }

    myGame : Game = DEFAULT_GAME
    myGameData : MyGameData = { 100 }
    myGame.data = &myGameData

    fmt.println((cast(^MyGameData)myGame.data))

    myGameTitle : GameState = DEFAULT_GAME_STATE
    myGameLoop : GameState = DEFAULT_GAME_STATE
    myGameSettings : GameState = DEFAULT_GAME_STATE

    myGame.isRunning = false

    myGameLoop->Pause()
    myGameSettings->Pause()

    myGameTitleIndex := myGame->AddState(&myGameTitle)
    myGameLoopIndex := myGame->AddState(&myGameLoop)
    myGameSettingsIndex := myGame->AddState(&myGameSettings)

    myGame->Update()
    myGame->Draw()

    myGameTitle->Stop()
    myGameTitle->Destroy()
    myGameLoop->Resume()
    myGameSettings->Resume()

    myGame->Update()
    myGame->Draw()

    entities: [dynamic]rawptr
    defer delete(entities)

    raylib.SetConfigFlags({.MSAA_4X_HINT})
    raylib.InitWindow(640, 512, "Odin - Raylib")
    defer raylib.CloseWindow()

    raylib.SetTargetFPS(60)

    //title_screen := raylib.LoadImageFromMemory(".png", &bitmaps.title_screen[0], i32(len(bitmaps.title_screen)))
    title_screen := raylib.LoadImage("/home/scottmoore/Workspace/github.com/scottjmoore/odintest/src/assets/graphics/bitmaps/bin/title_screen.png")
    title_screen_texture := raylib.LoadTextureFromImage(title_screen)

    shadow_texture := raylib.LoadRenderTexture(640, 512)
    defer raylib.UnloadRenderTexture(shadow_texture)
    raylib.SetTextureFilter(shadow_texture.texture, .BILINEAR)

    i1 := ItemCreate({100, 100}, {16, 16}, {255, 255, 0, 255})
    i2 := ItemCreate({540, 100}, {16, 16}, {255, 255, 0, 255})
    i3 := ItemCreate({540, 412}, {16, 16}, {255, 255, 0, 255})
    i4 := ItemCreate({100, 412}, {16, 16}, {255, 255, 0, 255})
    i5 := ItemCreate({200, 200}, {16, 16}, {255, 255, 0, 255})
    i6 := ItemCreate({440, 200}, {16, 16}, {255, 255, 0, 255})
    i7 := ItemCreate({440, 312}, {16, 16}, {255, 255, 0, 255})
    i8 := ItemCreate({200, 312}, {16, 16}, {255, 255, 0, 255})

    append(&entities, &i1)
    append(&entities, &i2)
    append(&entities, &i3)
    append(&entities, &i4)
    append(&entities, &i5)
    append(&entities, &i6)
    append(&entities, &i7)
    append(&entities, &i8)

    player := PlayerCreate(320, 256, 32)
    player2 := PlayerCreate(160, 128, 32)
    
    append(&entities, &player)
    append(&entities, &player2)

    for !raylib.WindowShouldClose() {
        raylib.BeginTextureMode(shadow_texture)
        raylib.ClearBackground({0, 0, 0, 0})

        for rp in entities {
            e := cast(^Entity)rp
            p := e^
            p.pos *= {1, -1}
            p.pos += {16, 500}
            p.angle *= -1
            p.angle += 180
            if e.state != .DESTROYED {
                p.Draw(&p)
            }
        }
        raylib.EndTextureMode()

        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLUE)
        raylib.DrawTexture(title_screen_texture, 0, 0, {255, 255, 255, 255})
        raylib.DrawTexture(shadow_texture.texture, 0, 0, {0, 0, 0, 64})
        
        for rp in entities {
            e := cast(^Entity)rp
            if e.state != .DESTROYED {
                e.Draw(e)
            }
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
                player2.vel.x -= max_speed * raylib.GetFrameTime()
            } else if raylib.IsKeyDown(.RIGHT) {
                player2.vel.x += max_speed * raylib.GetFrameTime()
            }

        if raylib.IsKeyDown(.UP) {
                player2.vel.y -= max_speed * raylib.GetFrameTime()
            } else if raylib.IsKeyDown(.DOWN) {
                player2.vel.y += max_speed * raylib.GetFrameTime()
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
        player2.vel -= (player2.vel - (player2.vel * 0.9))
        player2.pos += (player2.vel * raylib.GetFrameTime())
        
        angle := math.to_degrees(math.atan2(left.x, -left.y))
        player.angle = math.to_degrees(math.atan2(right.x, -right.y))

        player2.angle += 100 * raylib.GetFrameTime()

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
        raylib.DrawText(raylib.TextFormat("Health: %08i", player2.health), 412, 12, 20, raylib.BLACK)
        raylib.DrawText(raylib.TextFormat("Health: %08i", player2.health), 410, 10, 20, raylib.GREEN)

        when ODIN_DEBUG {
            raylib.DrawFPS(10, 480)
        }

        raylib.EndDrawing()

        for rp1 in entities {
            e1 := cast(^Entity)rp1

            if e1.type == Player {
                for rp2 in entities {
                    e2 := cast(^Entity)rp2

                    if e2.type == Item {
                        if raylib.Vector2Distance(e1.pos, e2.pos) < (e1.size.x + e2.size.x) {
                            if e2.state != .DESTROYED {
                                p := cast(^Player)e1
                                p.health += 100
                            }
                            e2.state = .DESTROYED
                        }
                    }
                }
            }
        }
    }
}